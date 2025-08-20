import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_app_bar.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_button.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/configs/date_format.dart';
import 'package:zapxx/configs/utils.dart';
import 'package:zapxx/model/services_model.dart';
import 'package:zapxx/repository/home_api/home_http_api_repository.dart';
import 'package:zapxx/view/nav_bar/photographer/home/business_builder/business_builder.dart';
import 'package:zapxx/view/nav_bar/photographer/home/business_builder/service_and_schedule/widget/custom_date_picker.dart';
import 'package:zapxx/view/nav_bar/user/home/filter/widgets/new_radio_item.dart';
import 'package:intl/intl.dart';
import 'package:zapxx/view_model/services/session_manager/session_controller.dart';
import 'package:flutter/services.dart';

class ServiceAndSchedule extends StatefulWidget {
  const ServiceAndSchedule({super.key});
  @override
  State<ServiceAndSchedule> createState() => _ServiceAndScheduleState();
}

class _ServiceAndScheduleState extends State<ServiceAndSchedule> {
  final List<ServiceModel> photographyServices = [];
  final List<ServiceModel> videographyServices = [];
  final List<String> selectedServiceIds = [];
  int selectedIndex = 0;
  int selectedCategory = 0;
  bool photographyServicesVisible = false;
  bool videographyServicesVisible = false;
  final TextEditingController _rateController = TextEditingController();

  // New variables for update mode
  bool isUpdateMode = false;
  int? existingSchedulerId;
  bool isLoadingExistingData = false;
  bool hasRefreshed = false; // Track if data has been refreshed

  void fetchServices() async {
    HomeHttpApiRepository repository = HomeHttpApiRepository();
    if (selectedIndex == 0) {
      ServicesModel servicesModel = await repository.fetchPhotographyList();
      setState(() {
        photographyServices.addAll(servicesModel.services);
      });
    } else {
      ServicesModel servicesModel = await repository.fetchVideographyList();
      setState(() {
        videographyServices.addAll(servicesModel.services);
      });
    }
  }

  Future<void> _updateBoolValue(String key, bool value) async {
    await SessionController.saveBool(key, value);
    setState(() {}); // Update UI if needed
  }

  List<Map<String, dynamic>> availabilityList = [];

  // New method to fetch existing scheduler data
  Future<void> fetchExistingSchedulerData() async {
    setState(() {
      isLoadingExistingData = true;
    });

    try {
      final token = SessionController().authModel.response.token;

      HomeHttpApiRepository repository = HomeHttpApiRepository();

      // First, fetch the seller data to get the seller ID
      final sellerResponse = await repository.fetchSeller({
        'Authorization': token,
        'Content-Type': 'application/json',
      });

      final sellerId = sellerResponse.user.seller.id;

      // Now fetch the scheduler using the seller ID
      final response = await repository.getSchedulerBySellerId(
        sellerId,
        headers: {'Authorization': token, 'Content-Type': 'application/json'},
      );

      if (response['sellerServices'] != null &&
          response['sellerServices']['Scheduler'] != null) {
        final scheduler = response['sellerServices']['Scheduler'];
        existingSchedulerId = scheduler['id'];

        // Populate existing data
        if (scheduler['SchedulerDate'] != null) {
          final schedulerDates = scheduler['SchedulerDate'] as List;
          availabilityList.clear();

          for (var dateData in schedulerDates) {
            final times = dateData['Time'] as List;
            final timeList =
                times.map<Map<String, dynamic>>((time) {
                  return {
                    'id': time['id'], // Keep the existing ID for updates
                    'startTime': time['startTime'],
                    'endTime': time['endTime'],
                    'rate': time['rate'] ?? 0,
                  };
                }).toList();

            availabilityList.add({'date': dateData['date'], 'times': timeList});
          }
        }

        // Set selected services if available
        if (response['sellerServices']['services'] != null) {
          final services = response['sellerServices']['services'] as List;
          selectedServiceIds.clear();
          for (var service in services) {
            selectedServiceIds.add(service['id'].toString());
          }
        }

        setState(() {
          isUpdateMode = true;
        });
      }
    } catch (e) {
      print('Error fetching existing scheduler: $e');
      // If no existing scheduler found, stay in create mode
    } finally {
      setState(() {
        isLoadingExistingData = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchServices();
    fetchExistingSchedulerData(); // Fetch existing data on init
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  // Method to refresh data
  Future<void> refreshData() async {
    // Clear existing data first
    setState(() {
      availabilityList.clear();
      selectedServiceIds.clear();
      isUpdateMode = false;
      existingSchedulerId = null;
    });

    // Fetch fresh data
    await fetchExistingSchedulerData();
  }

  // Method to show delete confirmation dialog
  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          backgroundColor: AppColors.whiteColor,
          title: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                  size: 24.w,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: CustomText(
                  text: 'Delete Scheduler',
                  fontSized: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackColor,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'Are you sure you want to delete this scheduler?',
                fontSized: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.blackColor,
              ),
              SizedBox(height: 8.h),
              CustomText(
                text:
                    'This action cannot be undone and will permanently remove all your scheduled time slots.',
                fontSized: 12.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.greyColor1,
              ),
            ],
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      decoration: BoxDecoration(
                        color: AppColors.lightGreyColor,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Center(
                        child: CustomText(
                          text: 'Cancel',
                          fontSized: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.blackColor,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      _deleteScheduler();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Center(
                        child: CustomText(
                          text: 'Delete',
                          fontSized: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
          actionsPadding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
        );
      },
    );
  }

  // Method to delete scheduler
  Future<void> _deleteScheduler() async {
    if (existingSchedulerId == null) return;

    setState(() {
      loading = true;
    });

    try {
      final repository = HomeHttpApiRepository();
      final token = SessionController().authModel.response.token;

      await repository.deleteScheduler(
        existingSchedulerId!,
        headers: {'Authorization': token, 'Content-Type': 'application/json'},
      );

      setState(() {
        loading = false;
      });

      Utils.flushBarSuccessMessage('Scheduler deleted successfully', context);

      _updateBoolValue(SessionController.boolKey2, true);

      // Navigate back after successful deletion
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const BusinessBuilder();
            },
          ),
        );
      });
    } catch (error) {
      setState(() {
        loading = false;
      });
      print('Error deleting scheduler: $error');
      Utils.flushBarErrorMessage(
        'Failed to delete scheduler: ${error.toString()}',
        context,
      );
    }
  }

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    HomeHttpApiRepository repository = HomeHttpApiRepository();
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(
        title:
            isUpdateMode
                ? 'Update Services and Schedule'
                : 'Services and Schedule',
        leadingIcon: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          if (isUpdateMode) ...[
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                refreshData();
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _showDeleteConfirmationDialog();
              },
            ),
          ],
        ],
        centerTitle: true,
      ),
      body:
          isLoadingExistingData
              ? const Center(child: CircularProgressIndicator())
              : GestureDetector(
                onTap: () {
                  // Hide keyboard when tapping outside
                  FocusScope.of(context).unfocus();
                },
                child: RefreshIndicator(
                  onRefresh: refreshData,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                      bottom: 100.h,
                    ), // Add padding to ensure save button is visible
                    child: Column(
                      children: [
                        const Divider(thickness: 1),
                        5.verticalSpace,
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Only show service selection in create mode
                              if (!isUpdateMode) ...[
                                CustomText(
                                  text: "Select Category",
                                  color: AppColors.blackColor,
                                  fontSized: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                                10.verticalSpace,
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedIndex = 0;
                                        });
                                      },
                                      child: Container(
                                        width: 160.w,
                                        height: 38.w,
                                        decoration: BoxDecoration(
                                          color:
                                              selectedIndex == 0
                                                  ? AppColors.backgroundColor
                                                  : AppColors.whiteColor,
                                          borderRadius: BorderRadius.circular(
                                            9.r,
                                          ),
                                        ),
                                        child: Center(
                                          child: CustomText(
                                            text: 'Photography',
                                            fontSized: 12.sp,
                                            fontWeight: FontWeight.w600,
                                            color:
                                                selectedIndex == 0
                                                    ? AppColors.whiteColor
                                                    : AppColors.blackColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 9.w),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedIndex = 1;
                                        });
                                        videographyServices.clear();
                                        fetchServices();
                                      },
                                      child: Container(
                                        width: 160.w,
                                        height: 38.w,
                                        decoration: BoxDecoration(
                                          color:
                                              selectedIndex == 1
                                                  ? AppColors.backgroundColor
                                                  : AppColors.whiteColor,
                                          borderRadius: BorderRadius.circular(
                                            9.r,
                                          ),
                                        ),
                                        child: Center(
                                          child: CustomText(
                                            text: 'Videography',
                                            fontSized: 12.sp,
                                            fontWeight: FontWeight.w600,
                                            color:
                                                selectedIndex == 1
                                                    ? AppColors.whiteColor
                                                    : AppColors.blackColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                15.verticalSpace,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomText(
                                      text: "Select Category",
                                      color: AppColors.blackColor,
                                      fontSized: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          // Toggle between showing all services or only the first two
                                          if (selectedIndex == 0) {
                                            photographyServicesVisible =
                                                !photographyServicesVisible;
                                          } else {
                                            videographyServicesVisible =
                                                !videographyServicesVisible;
                                          }
                                        });
                                      },
                                      child: CustomText(
                                        text:
                                            selectedIndex == 0
                                                ? (photographyServicesVisible
                                                    ? "Show Less"
                                                    : "See All")
                                                : (videographyServicesVisible
                                                    ? "Show Less"
                                                    : "See All"),
                                        color: AppColors.backgroundColor,
                                        fontSized: 14.sp,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                                10.verticalSpace,
                                GridView.count(
                                  crossAxisCount: 2,
                                  shrinkWrap: true,
                                  crossAxisSpacing: 10.w,
                                  mainAxisSpacing: 10.w,
                                  childAspectRatio: 5.5,
                                  physics: const NeverScrollableScrollPhysics(),
                                  children:
                                      selectedIndex == 0
                                          ? (photographyServicesVisible
                                                  ? photographyServices
                                                  : photographyServices.take(2))
                                              .map((service) {
                                                return RadioItemNew(
                                                  value: service.id.toString(),
                                                  title: service.name,
                                                  groupValues:
                                                      selectedServiceIds,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      if (selectedServiceIds
                                                          .contains(value)) {
                                                        selectedServiceIds
                                                            .remove(value);
                                                      } else {
                                                        selectedServiceIds.add(
                                                          value!,
                                                        );
                                                      }
                                                    });
                                                  },
                                                );
                                              })
                                              .toList()
                                          : (videographyServicesVisible
                                                  ? videographyServices
                                                  : videographyServices.take(2))
                                              .map((service) {
                                                return RadioItemNew(
                                                  value: service.id.toString(),
                                                  title: service.name,
                                                  groupValues:
                                                      selectedServiceIds,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      if (selectedServiceIds
                                                          .contains(value)) {
                                                        selectedServiceIds
                                                            .remove(value);
                                                      } else {
                                                        selectedServiceIds.add(
                                                          value!,
                                                        );
                                                      }
                                                    });
                                                  },
                                                );
                                              })
                                              .toList(),
                                ),
                                15.verticalSpace,
                              ],
                              CustomText(
                                text:
                                    isUpdateMode
                                        ? "Update Schedule"
                                        : "Create Schedule",
                                color: AppColors.blackColor,
                                fontSized: 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                              10.verticalSpace,
                              GestureDetector(
                                onTap: () async {
                                  final availableList = await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return const CustomDialogBox();
                                    },
                                  );
                                  setState(() {
                                    if (availableList != null) {
                                      availabilityList.addAll(availableList);
                                    }
                                  });
                                  print('new $availabilityList');
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.lightGreyColor,
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 15.w,
                                    vertical: 10.h,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomText(
                                        text: "Create your schedule",
                                        color: AppColors.greyColor1,
                                        fontSized: 12.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      const Icon(Icons.calendar_month_rounded),
                                    ],
                                  ),
                                ),
                              ),
                              10.verticalSpace,
                              if (availabilityList.isNotEmpty)
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxHeight:
                                        280.h, // Adjust this value as needed
                                  ),
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    itemCount:
                                        availabilityList
                                            .length, // Dynamic item count
                                    separatorBuilder:
                                        (context, index) => 10.verticalSpace,
                                    itemBuilder: (context, index) {
                                      final availability =
                                          availabilityList[index];
                                      // Parse the date from the first time slot's startTime to get the correct day
                                      final times =
                                          availability['times'] as List;
                                      final firstTimeSlot =
                                          times.isNotEmpty ? times.first : null;
                                      final date =
                                          firstTimeSlot != null
                                              ? DateTime.parse(
                                                firstTimeSlot['startTime'],
                                              )
                                              : DateTime.parse(
                                                availability['date'],
                                              );
                                      return Dismissible(
                                        key: Key(availability['date']),
                                        direction: DismissDirection.endToStart,
                                        onDismissed: (direction) {
                                          setState(() {
                                            availabilityList.removeAt(index);
                                          });
                                          Utils.flushBarSuccessMessage(
                                            'Schedule deleted successfully',
                                            context,
                                          );
                                        },
                                        background: Container(
                                          color: Colors.red,
                                          alignment: Alignment.centerRight,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 20.w,
                                          ),
                                          child: const Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          ),
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              10.r,
                                            ),
                                            color: const Color(0xffecf6f9),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 20.w,
                                            vertical: 10.h,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CustomText(
                                                text: DateFormat('EEEE').format(
                                                  date,
                                                ), // Format to get the day
                                                color: AppColors.greyColor1,
                                                fontSized: 12.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              ...times.asMap().entries.map((
                                                entry,
                                              ) {
                                                final i = entry.key;
                                                final time = entry.value;
                                                final startTime =
                                                    DateTime.parse(
                                                      time['startTime'],
                                                    );
                                                final endTime = DateTime.parse(
                                                  time['endTime'],
                                                );
                                                final rateController =
                                                    TextEditingController(
                                                      text:
                                                          (time['rate'] ?? 0)
                                                              .toString(),
                                                    );
                                                return Padding(
                                                  padding: EdgeInsets.only(
                                                    bottom: 6.h,
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 2,
                                                        child: CustomText(
                                                          text:
                                                              "${formatTime(startTime.toString())} - ${formatTime(endTime.toString())}",
                                                          color:
                                                              AppColors
                                                                  .greyColor1,
                                                          fontSized: 12.sp,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      SizedBox(width: 10.w),
                                                      Expanded(
                                                        flex: 1,
                                                        child: TextFormField(
                                                          controller:
                                                              rateController,
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          decoration: InputDecoration(
                                                            labelText: 'Rate',
                                                            border: OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    8.r,
                                                                  ),
                                                            ),
                                                            contentPadding:
                                                                EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      8.w,
                                                                  vertical: 8.h,
                                                                ),
                                                          ),
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                            color:
                                                                AppColors
                                                                    .blackColor,
                                                          ),
                                                          onChanged: (val) {
                                                            // Update the rate in the time slot
                                                            time['rate'] = val;
                                                            print(
                                                              'Rate updated for time slot: $val',
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }).toList(),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              10.verticalSpace,
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
        child: CustomButton(
          loading: loading,
          title: isUpdateMode ? "Update" : "Save",
          onPressed: () async {
            // Validate required fields
            if (!isUpdateMode && selectedServiceIds.isEmpty) {
              Utils.flushBarErrorMessage(
                'Please select at least one service',
                context,
              );
              return;
            }

            if (availabilityList.isEmpty) {
              Utils.flushBarErrorMessage(
                'Please create at least one schedule',
                context,
              );
              return;
            }

            // Validate rates are not null or empty (0 is acceptable)
            for (var date in availabilityList) {
              final times = date['times'] as List;
              for (var time in times) {
                final rate = time['rate'];
                if (rate == null || rate.toString().trim().isEmpty) {
                  Utils.flushBarErrorMessage(
                    'Please set rates for all time slots',
                    context,
                  );
                  return;
                }
              }
            }

            setState(() {
              loading = true;
            });

            print('Selected Services: $selectedServiceIds');
            print('Selected Category Index: $selectedIndex');
            print('Category ID: ${selectedIndex == 0 ? 1 : 2}');
            print('Availability List: $availabilityList');

            Map<String, dynamic> patchPayload = {
              "services":
                  selectedServiceIds
                      .map((id) => {"id": int.parse(id)})
                      .toList(),
              "schedulerDate":
                  availabilityList
                      .map(
                        (date) => {
                          "date": date['date'],
                          "times":
                              (date['times'] as List)
                                  .map(
                                    (time) => {
                                      "startTime": time['startTime'],
                                      "endTime": time['endTime'],
                                      "rate":
                                          int.tryParse(
                                            time['rate'].toString(),
                                          ) ??
                                          0,
                                    },
                                  )
                                  .toList(),
                        },
                      )
                      .toList(),
              "categoryId": selectedIndex == 0 ? 1 : 2,
            };
            String jsonData = jsonEncode(patchPayload);
            final token = SessionController().authModel.response.token;
            print('Payload: $jsonData');

            try {
              if (isUpdateMode && existingSchedulerId != null) {
                // Update existing scheduler
                await repository.updateScheduler(
                  existingSchedulerId!,
                  jsonData,
                  headers: {
                    'Authorization': token,
                    'Content-Type': 'application/json',
                  },
                );
                setState(() {
                  loading = false;
                });
                Utils.flushBarSuccessMessage(
                  'Scheduler updated Successfully',
                  context,
                );
                _updateBoolValue(SessionController.boolKey2, true);
                // Add delay to show the success message before navigation
                Future.delayed(Duration(seconds: 2), () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const BusinessBuilder();
                      },
                    ),
                  );
                });
              } else {
                // Create new scheduler
                await repository.createScheduler(
                  jsonData,
                  headers: {
                    'Authorization': token,
                    'Content-Type': 'application/json',
                  },
                );
                setState(() {
                  loading = false;
                });
                Utils.flushBarSuccessMessage(
                  'Scheduler added Successfully',
                  context,
                );
                _updateBoolValue(SessionController.boolKey2, true);
                // Add delay to show the success message before navigation
                Future.delayed(Duration(seconds: 2), () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const BusinessBuilder();
                      },
                    ),
                  );
                });
              }
            } catch (error) {
              setState(() {
                loading = false;
              });
              print(error);
              Utils.flushBarErrorMessage(error.toString(), context);
              _updateBoolValue(SessionController.boolKey2, true);
              Future.delayed(Duration(seconds: 2), () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const BusinessBuilder();
                    },
                  ),
                );
              });
            }
          },
          btnColor: AppColors.backgroundColor,
          btnTextColor: AppColors.whiteColor,
        ),
      ),
    );
  }
}
