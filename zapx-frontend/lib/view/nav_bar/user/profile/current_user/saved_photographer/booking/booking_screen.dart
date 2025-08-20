import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:zapxx/configs/app_url.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_button.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/configs/utils.dart';
import 'package:zapxx/view/nav_bar/user/home/services/widgets/scheduler_type_model.dart';
import 'package:zapxx/view/nav_bar/user/profile/current_user/saved_photographer/booking/booking_summary_Screen.dart';
import 'package:zapxx/view/nav_bar/user/profile/current_user/saved_photographer/booking/widgets/booking_input_text_field.dart';
import 'package:zapxx/view/nav_bar/user/profile/current_user/saved_photographer/booking/widgets/exmple_image_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zapxx/view_model/services/session_manager/session_controller.dart';
import 'package:zapxx/view_model/user_view_model.dart';
import 'package:mime/src/mime_type.dart';
import 'package:intl/intl.dart';

class BookingScreen extends StatefulWidget {
  final int sellerId;
  final TimeSlot? selectedSlot;
  const BookingScreen({super.key, required this.sellerId, this.selectedSlot});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController addNotesController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  String? _selectedDueDate;
  String? _selectedDueDateLocal;
  String? _selectedDate;
  String? _selectedDateLocal;
  String? _selectedTime;
  String? _selectedEndTime;
  String? _selectedEndTimeLocal;
  String? _selectedTimeLocal;

  List<File> imageFiles = []; // Store picked files
  bool _isLoading = false; // Local loading state

  @override
  void initState() {
    super.initState();
    // Load consumer data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadConsumerData();
      _initializeSelectedSlot();
    });
  }

  void _initializeSelectedSlot() {
    if (widget.selectedSlot != null) {
      setState(() {
        // Create date with 00:00:00Z time
        _selectedDate =
            DateTime.utc(
              widget.selectedSlot!.startTime.year,
              widget.selectedSlot!.startTime.month,
              widget.selectedSlot!.startTime.day,
            ).toIso8601String();
        _selectedDateLocal =
            "${widget.selectedSlot!.startTime.year}-${widget.selectedSlot!.startTime.month.toString().padLeft(2, '0')}-${widget.selectedSlot!.startTime.day.toString().padLeft(2, '0')}";
        _selectedTimeLocal = widget.selectedSlot!.startTime.toIso8601String();
        _selectedEndTimeLocal = widget.selectedSlot!.endTime.toIso8601String();
        _selectedTime = DateFormat(
          'h:mm a',
        ).format(widget.selectedSlot!.startTime);
        _selectedEndTime = DateFormat(
          'h:mm a',
        ).format(widget.selectedSlot!.endTime);
      });
    }
  }

  Future<void> _loadConsumerData() async {
    try {
      final userProvider = Provider.of<UserViewModel>(context, listen: false);
      if (userProvider.userConsumer == null) {
        await userProvider.fetchConsumerData();
      }
    } catch (e) {
      print('Error loading consumer data: $e');
    }
  }

  Future<void> _addBookingApi() async {
    try {
      final userProvider = Provider.of<UserViewModel>(context, listen: false);

      // Ensure consumer data is loaded
      if (userProvider.userConsumer == null) {
        await _loadConsumerData();
      }

      final consumer = userProvider.userConsumer;
      print('Consumer: $consumer');
      if (consumer == null) {
        Utils.flushBarErrorMessage('User data not available', context);
        return;
      }

      final dio = Dio(BaseOptions(baseUrl: AppUrl.baseUrl));
      final token = SessionController().authModel.response.token;

      final formData = FormData();
      for (var image in imageFiles) {
        formData.files.addAll([
          MapEntry(
            'image',
            await MultipartFile.fromFile(
              image.path,
              filename: image.path.split('/').last,
              contentType: DioMediaType.parse(
                lookupMimeType(image.path) ?? 'application/octet-stream',
              ),
            ),
          ),
        ]);
      }

      formData.fields.addAll([
        MapEntry('startTime', _selectedTimeLocal ?? ''),
        MapEntry('endTime', _selectedEndTimeLocal ?? ''),
        MapEntry('date', _selectedDate ?? ''),
        MapEntry('deliveryDate', _selectedDueDate ?? ''),
        MapEntry('reminderTime', ''),
        MapEntry('location', locationController.text.trim()),
        MapEntry('description', descriptionController.text.trim()),
        MapEntry('notes', addNotesController.text.trim()),
        MapEntry('sellerId', widget.sellerId.toString()),
        MapEntry('consumerId', consumer.consumer!.id.toString()),
      ]);
      print('FormData: ${formData.fields}');
      print('Files: ${formData.files}');
      print('Debug - startTime: ${_selectedTimeLocal}');
      print('Debug - endTime: ${_selectedEndTimeLocal}');
      print('Debug - date: ${_selectedDate}');
      print('Debug - deliveryDate: ${_selectedDueDate}');

      final response = await dio.post(
        AppUrl.booking,
        data: formData,
        options: Options(
          headers: {'Authorization': token, 'Accept': 'application/json'},
          contentType: 'multipart/form-data',
        ),
      );

      print('Upload response: ${response.data}');
      if (response.statusCode == 200) {
        Utils.flushBarSuccessMessage(
          response.data['message'].toString(),
          context,
        );

        print('Booking successful: ${response.data['booking']['id']}');
        print('Debug - Selected Time: $_selectedTime');
        print('Debug - Selected End Time: $_selectedEndTime');
        print('Debug - Selected Date Local: $_selectedDateLocal');
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (context) => BookingSummaryScreen(
                    id: response.data['booking']['id'],
                    duration:
                        (() {
                          if (_selectedTimeLocal != null &&
                              _selectedEndTimeLocal != null) {
                            final startTime = DateTime.parse(
                              _selectedTimeLocal!,
                            );
                            final endTime = DateTime.parse(
                              _selectedEndTimeLocal!,
                            );
                            final difference = endTime.difference(startTime);
                            final hours = difference.inHours;
                            final minutes = difference.inMinutes.remainder(60);
                            return '${hours > 0 ? '$hours hr ' : ''}${minutes > 0 ? '$minutes minutes' : ''}'
                                .trim();
                          }
                          return '0 minutes';
                        })(),
                    selectedSlot: {
                      'startTime': _selectedTime ?? 'N/A',
                      'endTime': _selectedEndTime ?? 'N/A',
                      'date': DateFormat(
                        'MMM dd, yyyy',
                      ).format(DateTime.parse(_selectedDateLocal!)),
                      'id': 'custom',
                    },
                    addNotes: addNotesController.text.toString(),
                    description: descriptionController.text.toString(),
                    images: imageFiles.map((e) => e.path).toList(),
                  ),
            ),
          );
        });
      }
    } on DioException catch (e) {
      print('Upload error: ${e.response?.data}');
      Utils.flushBarErrorMessage(
        e.response?.data['message'] ?? 'Upload failed',
        context,
      );
    } catch (e) {
      print('General error: $e');
      Utils.flushBarErrorMessage('Upload failed: $e', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back_ios, color: AppColors.blackColor),
        ),
        title: const CustomText(
          text: 'Booking',
          fontSized: 18.0,
          fontWeight: FontWeight.w600,
          color: AppColors.blackColor,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Divider(thickness: 1),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 25.w),
                  // Location
                  const CustomText(
                    text: 'Location',
                    fontSized: 14.0,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackColor,
                  ),
                  SizedBox(height: 8.w),
                  BookingInputTextField(
                    controller: locationController,
                    hintText: 'Enter location',
                    height: 80.w,
                    maxLines: 2,
                  ),

                  // Delivery Date
                  SizedBox(height: 11.w),
                  const CustomText(
                    text: 'Delivery Date',
                    fontSized: 14.0,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackColor,
                  ),
                  SizedBox(height: 8.w),
                  GestureDetector(
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now().add(
                          const Duration(days: 1),
                        ),
                        firstDate: DateTime.now().add(const Duration(days: 1)),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _selectedDueDate =
                              pickedDate.toUtc().toIso8601String();
                          _selectedDueDateLocal =
                              "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                        });
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 15.w,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _selectedDueDateLocal != null
                                  ? _selectedDueDateLocal!
                                  : 'Select delivery date',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'nunito Sans',
                                color:
                                    _selectedDueDateLocal != null
                                        ? AppColors.blackColor
                                        : AppColors.greyColor.withOpacity(0.5),
                              ),
                            ),
                          ),
                          Image(
                            width: 16.w,
                            height: 16.w,
                            color: AppColors.blackColor,
                            image: const AssetImage(
                              'assets/images/Calendar.png',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Description
                  SizedBox(height: 11.w),
                  const CustomText(
                    text: 'Description',
                    fontSized: 14.0,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackColor,
                  ),
                  SizedBox(height: 8.w),
                  BookingInputTextField(
                    hintText: 'Description here',
                    height: 80.w,
                    maxLines: 2,
                    controller: descriptionController,
                  ),
                  SizedBox(height: 11.w),
                  const CustomText(
                    text: 'Add Notes',
                    fontSized: 14.0,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackColor,
                  ),
                  SizedBox(height: 8.w),
                  BookingInputTextField(
                    hintText: 'Write nots here...',
                    height: 140.w,
                    maxLines: 4,
                    controller: addNotesController,
                  ),
                  SizedBox(height: 11.w),
                  const CustomText(
                    text: 'Example Pictures',
                    fontSized: 14.0,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackColor,
                  ),
                  SizedBox(height: 12.w),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final pickedFile = await ImagePicker().pickImage(
                            source: ImageSource.gallery,
                          );
                          if (pickedFile != null) {
                            setState(() {
                              imageFiles.add(File(pickedFile.path));
                            });
                          }
                        },
                        child: Container(
                          width: 70.w,
                          height: 70.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: const DecorationImage(
                              image: AssetImage('assets/images/dot_border.png'),
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.add,
                              size: 28,
                              color: AppColors.backgroundColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: SizedBox(
                          height: 70.w,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: imageFiles.length,
                            itemBuilder: (context, index) {
                              return ExamplePictureWidget(
                                key: ValueKey(
                                  imageFiles[index],
                                ), // Ensure unique key
                                image: imageFiles[index].path,
                                index: index,
                                onDelete: (index) {
                                  setState(() {
                                    imageFiles.removeAt(
                                      index,
                                    ); // Remove image from the list
                                  });
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.w),
                  const CustomText(
                    text: 'Selected Time Slot',
                    fontSized: 14.0,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackColor,
                  ),
                  SizedBox(height: 8.w),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 15.w,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.selectedSlot != null
                                ? '${DateFormat('MMM dd, yyyy').format(widget.selectedSlot!.startTime)} ${DateFormat('h:mm a').format(widget.selectedSlot!.startTime)} - ${DateFormat('h:mm a').format(widget.selectedSlot!.endTime)}'
                                : 'No time slot selected',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'nunito Sans',
                              color: AppColors.blackColor,
                            ),
                          ),
                        ),
                        Image(
                          width: 16.w,
                          height: 16.w,
                          color: AppColors.blackColor,
                          image: const AssetImage('assets/images/Calendar.png'),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 40.w),
                  Center(
                    child: CustomButton(
                      loading: _isLoading,
                      title: 'Submit',
                      onPressed: () {
                        // Validate required fields
                        if (locationController.text.trim().isEmpty) {
                          Utils.flushBarErrorMessage(
                            'Please enter location',
                            context,
                          );
                          return;
                        }
                        if (_selectedDueDateLocal == null) {
                          Utils.flushBarErrorMessage(
                            'Please select delivery date',
                            context,
                          );
                          return;
                        }
                        if (descriptionController.text.trim().isEmpty) {
                          Utils.flushBarErrorMessage(
                            'Please enter description',
                            context,
                          );
                          return;
                        }

                        setState(() {
                          _isLoading = true;
                        });

                        _addBookingApi()
                            .then((_) {
                              setState(() {
                                _isLoading = false;
                              });
                            })
                            .catchError((error) {
                              setState(() {
                                _isLoading = false;
                              });
                              Utils.flushBarErrorMessage(
                                'Failed to send booking request: $error',
                                context,
                              );
                            });
                      },
                      btnColor: AppColors.backgroundColor,
                      btnTextColor: AppColors.whiteColor,
                    ),
                  ),
                  SizedBox(height: 40.w),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
