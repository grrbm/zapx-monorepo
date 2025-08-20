import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:share_plus/share_plus.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_app_bar.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_button.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/configs/utils.dart';
import 'package:zapxx/repository/home_api/home_http_api_repository.dart';
import 'package:zapxx/view/nav_bar/user/booking/booking_schedule_screen.dart';

import 'package:zapxx/view_model/services/session_manager/session_controller.dart';
import 'package:zapxx/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

Future<TimeOfDay?> pickTime(BuildContext context) async {
  if (Platform.isIOS) {
    TimeOfDay? selectedTime;
    await showCupertinoModalPopup(
      context: context,
      builder: (context) {
        DateTime now = DateTime.now();
        DateTime tempPicked = now;
        return Container(
          height: 270, // Increased from 250 to prevent overflow
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 200,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: now,
                  use24hFormat: false,
                  onDateTimeChanged: (DateTime newTime) {
                    tempPicked = newTime;
                  },
                ),
              ),
              CupertinoButton(
                child: Text('OK'),
                onPressed: () {
                  selectedTime = TimeOfDay(
                    hour: tempPicked.hour,
                    minute: tempPicked.minute,
                  );
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
    return selectedTime;
  } else {
    return await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
    );
  }
}

class AddBookingExternalScreen extends StatefulWidget {
  const AddBookingExternalScreen({super.key});

  @override
  State<AddBookingExternalScreen> createState() =>
      _AddBookingExternalScreenState();
}

class _AddBookingExternalScreenState extends State<AddBookingExternalScreen> {
  String? _selectedDate;
  String? _selectedDateLocal;
  String? _selectedDueDate;
  String? _selectedDueDateLocal;
  String? _selectedTime;
  String? _selectedEndTime;
  String? _selectedEndTimeLocal;
  String? _selectedTimeLocal;
  final TextEditingController clientNameController = TextEditingController();
  final TextEditingController clientEmailController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  @override
  void dispose() {
    clientNameController.dispose();
    clientEmailController.dispose();
    locationController.dispose();
    descriptionController.dispose();
    notesController.dispose();
    priceController.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>?> _showCustomDateTimePicker() async {
    DateTime? selectedStartDate;
    DateTime? selectedDueDate;
    TimeOfDay? selectedStartTime;
    TimeOfDay? selectedEndTime;

    // Step 1: Date Selection
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setDialogState) => Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  backgroundColor: AppColors.whiteColor,
                  child: Container(
                    height: 400.h,
                    width: 330.w,
                    padding: EdgeInsets.symmetric(
                      vertical: 20.h,
                      horizontal: 20.w,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: "Select Dates",
                          color: AppColors.blackColor,
                          fontSized: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        Column(
                          children: [
                            // Start Date
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 12.h,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                                color: AppColors.lightGreyColor,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    text: "Start Date",
                                    color: AppColors.blackColor,
                                    fontSized: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      DateTime? pickedDate =
                                          await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime(2101),
                                          );
                                      if (pickedDate != null) {
                                        setDialogState(() {
                                          selectedStartDate = pickedDate;
                                        });
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12.w,
                                        vertical: 8.h,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                        color: AppColors.backgroundColor,
                                      ),
                                      child: CustomText(
                                        text:
                                            selectedStartDate != null
                                                ? "${selectedStartDate!.day}/${selectedStartDate!.month}/${selectedStartDate!.year}"
                                                : "Select",
                                        color: AppColors.whiteColor,
                                        fontSized: 12.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 16.h),
                            // Due Date
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 12.h,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                                color: AppColors.lightGreyColor,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    text: "Due Date",
                                    color: AppColors.blackColor,
                                    fontSized: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      DateTime?
                                      pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate:
                                            selectedStartDate ?? DateTime.now(),
                                        firstDate:
                                            selectedStartDate ?? DateTime.now(),
                                        lastDate: DateTime(2101),
                                      );
                                      if (pickedDate != null) {
                                        setDialogState(() {
                                          selectedDueDate = pickedDate;
                                        });
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12.w,
                                        vertical: 8.h,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                        color: AppColors.backgroundColor,
                                      ),
                                      child: CustomText(
                                        text:
                                            selectedDueDate != null
                                                ? "${selectedDueDate!.day}/${selectedDueDate!.month}/${selectedDueDate!.year}"
                                                : "Select",
                                        color: AppColors.whiteColor,
                                        fontSized: 12.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomButton(
                              title: "Cancel",
                              onPressed: () => Navigator.pop(context),
                              btnColor: AppColors.whiteColor,
                              btnTextColor: AppColors.redColor,
                              borderRadius: 20,
                              width: 100.w,
                              height: 35.h,
                            ),
                            CustomButton(
                              title: "Next",
                              onPressed: () {
                                if (selectedStartDate != null &&
                                    selectedDueDate != null) {
                                  Navigator.pop(context);
                                } else {
                                  Utils.flushBarErrorMessage(
                                    "Please select both dates",
                                    context,
                                  );
                                }
                              },
                              btnColor: AppColors.backgroundColor,
                              btnTextColor: AppColors.whiteColor,
                              borderRadius: 20,
                              width: 100.w,
                              height: 35.h,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
          ),
    );

    // Step 2: Time Selection
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setDialogState) => Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  backgroundColor: AppColors.whiteColor,
                  child: Container(
                    height: 400.h,
                    width: 330.w,
                    padding: EdgeInsets.symmetric(
                      vertical: 20.h,
                      horizontal: 20.w,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: "Select Times",
                          color: AppColors.blackColor,
                          fontSized: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        Column(
                          children: [
                            // Start Time
                            Container(
                              height: 120.h,
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                                vertical: 10.h,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.r),
                                color: AppColors.lightGreyColor,
                              ),
                              child: Column(
                                children: [
                                  CustomText(
                                    text: "Start Time",
                                    color: AppColors.blackColor,
                                    fontSized: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  SizedBox(height: 8.h),
                                  Expanded(
                                    child: TimePickerSpinner(
                                      normalTextStyle: TextStyle(
                                        fontSize: 16.sp,
                                        color: AppColors.backgroundColor
                                            .withOpacity(0.5),
                                      ),
                                      highlightedTextStyle: TextStyle(
                                        fontSize: 18.sp,
                                        color: AppColors.blackColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      spacing: 0,
                                      itemHeight: 30,
                                      isForce2Digits: true,
                                      alignment: Alignment.center,
                                      is24HourMode: false,
                                      onTimeChange: (time) {
                                        setDialogState(() {
                                          selectedStartTime =
                                              TimeOfDay.fromDateTime(time);
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 16.h),
                            // End Time
                            Container(
                              height: 120.h,
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                                vertical: 10.h,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.r),
                                color: AppColors.lightGreyColor,
                              ),
                              child: Column(
                                children: [
                                  CustomText(
                                    text: "End Time",
                                    color: AppColors.blackColor,
                                    fontSized: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  SizedBox(height: 8.h),
                                  Expanded(
                                    child: TimePickerSpinner(
                                      normalTextStyle: TextStyle(
                                        fontSize: 16.sp,
                                        color: AppColors.backgroundColor
                                            .withOpacity(0.5),
                                      ),
                                      highlightedTextStyle: TextStyle(
                                        fontSize: 18.sp,
                                        color: AppColors.blackColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      spacing: 0,
                                      itemHeight: 30,
                                      isForce2Digits: true,
                                      alignment: Alignment.center,
                                      is24HourMode: false,
                                      onTimeChange: (time) {
                                        setDialogState(() {
                                          selectedEndTime =
                                              TimeOfDay.fromDateTime(time);
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomButton(
                              title: "Back",
                              onPressed: () => Navigator.pop(context),
                              btnColor: AppColors.whiteColor,
                              btnTextColor: AppColors.backgroundColor,
                              borderRadius: 20,
                              width: 100.w,
                              height: 35.h,
                            ),
                            CustomButton(
                              title: "Apply",
                              onPressed: () {
                                if (selectedStartTime != null &&
                                    selectedEndTime != null) {
                                  Navigator.pop(context);
                                } else {
                                  Utils.flushBarErrorMessage(
                                    "Please select both times",
                                    context,
                                  );
                                }
                              },
                              btnColor: AppColors.backgroundColor,
                              btnTextColor: AppColors.whiteColor,
                              borderRadius: 20,
                              width: 100.w,
                              height: 35.h,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
          ),
    );

    if (selectedStartDate != null &&
        selectedDueDate != null &&
        selectedStartTime != null &&
        selectedEndTime != null) {
      return {
        'startDate': selectedStartDate,
        'dueDate': selectedDueDate,
        'startTime': selectedStartTime,
        'endTime': selectedEndTime,
      };
    }

    return null;
  }

  void showInviteBottomSheet(BuildContext context) async {
    final result = await Share.share(
      'Check out ZapX: www.zapxapp.com',
      subject: 'ZapX',
    );
    if (result.status == ShareResultStatus.success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Invitation sent!')));
    }
  }

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserViewModel>(context, listen: false);
    HomeHttpApiRepository repository = HomeHttpApiRepository();
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: const CustomAppBar(title: 'Add External Booking'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Divider(color: AppColors.greyColor.withOpacity(0.2)),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: SizedBox(
                width: 327.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 12.w),
                    CustomText(
                      text: 'Client Name',
                      fontSized: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                      alignment: TextAlign.start,
                    ),
                    SizedBox(height: 8.w),
                    TextField(
                      style: TextStyle(color: Colors.black),
                      controller: clientNameController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 15.w,
                        ),
                        hintText: 'Client Name',
                        hintStyle: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'nunito Sans',
                          color: AppColors.greyColor.withOpacity(0.5),
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                      ),
                    ),
                    SizedBox(height: 16.w),
                    CustomText(
                      text: 'Client Email',
                      fontSized: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                      alignment: TextAlign.start,
                    ),
                    SizedBox(height: 8.w),
                    TextField(
                      style: TextStyle(color: Colors.black),
                      controller: clientEmailController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 15.w,
                        ),
                        hintText: 'Client Email',
                        hintStyle: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'nunito Sans',
                          color: AppColors.greyColor.withOpacity(0.5),
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24.r),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.w),
                    CustomText(
                      text: 'Date & Time',
                      fontSized: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                      alignment: TextAlign.start,
                    ),
                    SizedBox(height: 8.w),
                    TextField(
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'nunito Sans',
                        color: AppColors.blackColor,
                      ),
                      controller: TextEditingController(
                        text:
                            _selectedDateLocal != null && _selectedTime != null
                                ? '${_selectedDateLocal} ${_selectedTime} - ${_selectedEndTime}'
                                : 'Select date and time',
                      ),
                      readOnly: true,
                      onTap: () async {
                        final result = await _showCustomDateTimePicker();
                        if (result != null) {
                          final startDate = result['startDate'] as DateTime;
                          final dueDate = result['dueDate'] as DateTime;
                          final startTime = result['startTime'] as TimeOfDay;
                          final endTime = result['endTime'] as TimeOfDay;

                          // Convert to required format
                          final startDateTime = DateTime(
                            startDate.year,
                            startDate.month,
                            startDate.day,
                            startTime.hour,
                            startTime.minute,
                          );
                          final endDateTime = DateTime(
                            startDate.year,
                            startDate.month,
                            startDate.day,
                            endTime.hour,
                            endTime.minute,
                          );

                          setState(() {
                            _selectedDate = startDate.toUtc().toIso8601String();
                            _selectedDateLocal =
                                "${startDate.toLocal()}".split(' ')[0];
                            _selectedDueDate =
                                dueDate.toUtc().toIso8601String();
                            _selectedDueDateLocal =
                                "${dueDate.toLocal()}".split(' ')[0];
                            _selectedTime = startTime.format(context);
                            _selectedTimeLocal =
                                startDateTime.toUtc().toIso8601String();
                            _selectedEndTime = endTime.format(context);
                            _selectedEndTimeLocal =
                                endDateTime.toUtc().toIso8601String();
                          });
                        }
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 15.w,
                        ),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Image(
                            width: 16.w,
                            height: 16.w,
                            color: AppColors.blackColor,
                            image: const AssetImage(
                              'assets/images/Calendar.png',
                            ),
                          ),
                        ),
                        hintText: 'Select date and time',
                        hintStyle: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'nunito Sans',
                          color: AppColors.greyColor.withOpacity(0.5),
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24.r),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.w),
                    CustomText(
                      text: 'Location',
                      fontSized: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                      alignment: TextAlign.start,
                    ),
                    SizedBox(height: 8.w),
                    TextField(
                      style: TextStyle(color: Colors.black),
                      controller: locationController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 15.w,
                        ),
                        hintText: 'Location',
                        hintStyle: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'nunito Sans',
                          color: AppColors.greyColor.withOpacity(0.5),
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24.r),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.w),
                    CustomText(
                      text: 'Brief Description',
                      fontSized: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                      alignment: TextAlign.start,
                    ),
                    SizedBox(height: 8.w),
                    TextField(
                      style: TextStyle(color: Colors.black),
                      controller: descriptionController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 15.w,
                        ),
                        hintText: 'Brief description',
                        hintStyle: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'nunito Sans',
                          color: AppColors.greyColor.withOpacity(0.5),
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24.r),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.w),
                    CustomText(
                      text: 'Notes',
                      fontSized: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                      alignment: TextAlign.start,
                    ),
                    SizedBox(height: 8.w),
                    TextField(
                      style: TextStyle(color: Colors.black),
                      controller: notesController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 15.w,
                        ),
                        hintText: 'Notes',
                        hintStyle: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'nunito Sans',
                          color: AppColors.greyColor.withOpacity(0.5),
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24.r),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.w),
                    CustomText(
                      text: 'Price',
                      fontSized: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                      alignment: TextAlign.start,
                    ),
                    SizedBox(height: 8.w),
                    TextField(
                      style: TextStyle(color: Colors.black),
                      controller: priceController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 15.w,
                        ),
                        hintText: 'Price',
                        hintStyle: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'nunito Sans',
                          color: AppColors.greyColor.withOpacity(0.5),
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24.r),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    CustomButton(
                      loading: loading,
                      title: 'Add to schedule',
                      onPressed: () async {
                        setState(() {
                          loading = true;
                        });
                        // Future.delayed(Duration(seconds: 2));

                        var sellerId = await SessionController.getSellerId(
                          'sellerId',
                        );
                        print('USer Id $sellerId');
                        Map data = {
                          "startTime": _selectedTimeLocal,
                          "endTime": _selectedEndTimeLocal,
                          "deliveryDate": _selectedDueDateLocal,
                          "notes": notesController.text,
                          "description": descriptionController.text,
                          "date": _selectedDateLocal,
                          "location": locationController.text,
                          "price": priceController.text,
                          "sellerId": sellerId,
                          "clientName": clientNameController.text,
                          "consumerEmail": clientEmailController.text,
                        };
                        String jsonData = jsonEncode(data);
                        final token =
                            SessionController().authModel.response.token;
                        repository
                            .createexternalBooking(
                              jsonData,
                              headers: {
                                'Authorization': token,
                                'Content-Type': 'application/json',
                              },
                            )
                            .then((value) {
                              Utils.flushBarSuccessMessage(
                                'Booking added Successfully',
                                context,
                              );
                              setState(() {
                                loading = false;
                              });

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const BookingScheduleScreen();
                                  },
                                ),
                              );
                            })
                            .onError((error, stackTrace) {
                              print(error);
                              setState(() {
                                loading = false;
                              });
                              Utils.flushBarErrorMessage(
                                error.toString(),
                                context,
                              );
                            });
                      },
                      btnColor: AppColors.backgroundColor,
                      btnTextColor: AppColors.whiteColor,
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        showInviteBottomSheet(context);
                      },
                      child: Container(
                        width: 327.w,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: AppColors.blackColor),
                          borderRadius: BorderRadius.circular(100.r),
                        ),
                        child: Center(
                          child: CustomText(
                            text: 'Share',
                            fontSized: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.blackColor,
                            alignment: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
