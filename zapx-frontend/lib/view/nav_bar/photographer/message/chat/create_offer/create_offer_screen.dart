import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapxx/configs/app_url.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_app_bar.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_button.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/configs/utils.dart';
import 'package:zapxx/view_model/services/session_manager/session_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:mime/mime.dart';
import 'package:intl/intl.dart';

class CreateOfferScreen extends StatefulWidget {
  final String? receiverId;
  final String? receiverName;

  const CreateOfferScreen({super.key, this.receiverId, this.receiverName});

  @override
  State<CreateOfferScreen> createState() => _CreateOfferScreenState();
}

class _CreateOfferScreenState extends State<CreateOfferScreen> {
  final TextEditingController locationController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  String? _selectedDate;
  String? _selectedDateLocal;
  String? _selectedDueDate;
  String? _selectedDueDateLocal;
  String? _selectedStartTime;
  String? _selectedStartTimeLocal;
  String? _selectedEndTime;
  String? _selectedEndTimeLocal;

  List<File> imageFiles = [];
  bool isLoading = false;

  Future<void> _sendOfferMessage() async {
    try {
      final dio = Dio(BaseOptions(baseUrl: AppUrl.baseUrl));
      final token = SessionController().authModel.response.token;

      // Create offer message with special identifier
      String offerMessage =
          '[OFFER] I have sent you an offer for your booking request.';
      if (widget.receiverName != null && widget.receiverName!.isNotEmpty) {
        offerMessage =
            '[OFFER] Hi ${widget.receiverName}, I have sent you an offer for your booking request.';
      }

      final formData = FormData();
      formData.fields.addAll([
        MapEntry('receiverId', widget.receiverId ?? ''),
        MapEntry('message', offerMessage),
      ]);

      print('📤 Sending offer message to chat...');

      final response = await dio.post(
        AppUrl.sendMessages,
        data: formData,
        options: Options(
          headers: {'Authorization': token, 'Accept': 'application/json'},
          contentType: 'multipart/form-data',
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

      print('✅ Offer message sent: ${response.statusCode}');
    } catch (e) {
      print('⚠️ Failed to send offer message: $e');
      // Don't show error to user as offer was created successfully
    }
  }

  Future<void> _createOfferApi() async {
    if (!_validateForm()) return;

    setState(() {
      isLoading = true;
    });

    print('🚀 Starting create offer API call...');
    print('📋 Form data:');
    print('  - Location: ${locationController.text.trim()}');
    print('  - Price: ${priceController.text.trim()}');
    print('  - Description: ${descriptionController.text.trim()}');
    print('  - Notes: ${notesController.text.trim()}');
    print('  - Date: $_selectedDateLocal');
    print('  - Start Time: $_selectedStartTimeLocal');
    print('  - End Time: $_selectedEndTimeLocal');
    print('  - Consumer ID: ${widget.receiverId}');
    print('  - Delivery Date: $_selectedDueDateLocal');
    print('  - Images count: ${imageFiles.length}');

    try {
      final dio = Dio(BaseOptions(baseUrl: AppUrl.baseUrl));
      final token = SessionController().authModel.response.token;
      var sellerId = await SessionController.getSellerId('sellerId');

      print('🔑 Token: ${token.substring(0, 20)}...');
      print('👤 Seller ID: $sellerId');

      // Validate seller ID and consumer ID
      if (sellerId == 0) {
        throw Exception('Invalid seller ID. Please try logging in again.');
      }

      if (widget.receiverId == null || widget.receiverId!.isEmpty) {
        throw Exception('Invalid consumer ID. Please try again.');
      }

      final formData = FormData();

      // Add images
      for (var i = 0; i < imageFiles.length; i++) {
        var image = imageFiles[i];
        print('📸 Adding image ${i + 1}: ${image.path}');
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

      // Add form fields
      formData.fields.addAll([
        MapEntry('location', locationController.text.trim()),
        MapEntry('price', priceController.text.trim()),
        MapEntry('description', descriptionController.text.trim()),
        MapEntry('notes', notesController.text.trim()),
        MapEntry('date', _selectedDateLocal ?? ''),
        MapEntry('startTime', _selectedStartTimeLocal ?? ''),
        MapEntry(
          'endTime',
          _selectedEndTimeLocal ?? '',
        ), // Fixed: was duplicate startTime
        MapEntry('sellerId', sellerId.toString()),
        MapEntry('consumerId', widget.receiverId ?? ''),
        MapEntry('deliveryDate', _selectedDueDateLocal ?? ''),
      ]);

      print('📤 Sending request to: ${AppUrl.createOffer}');
      print('📦 FormData fields: ${formData.fields}');
      print('📦 FormData files: ${formData.files.length}');

      final response = await dio.post(
        AppUrl.createOffer,
        data: formData,
        options: Options(
          headers: {'Authorization': token, 'Accept': 'application/json'},
          contentType: 'multipart/form-data',
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      print('✅ Response received: ${response.statusCode}');
      print('📄 Response data: ${response.data}');

      if (response.statusCode == 200) {
        print('🎉 Offer created successfully!');
        if (mounted) {
          print('📱 Widget is still mounted, proceeding with success flow...');

          // Send offer message to chat
          print('💬 Sending offer message...');
          await _sendOfferMessage();
          print('✅ Offer message sent');

          print('🚀 Navigating back immediately...');
          // Pass offer data back to the chat screen
          Navigator.pop(context, {
            'success': true,
            'offerData': {
              'location': locationController.text.trim(),
              'price': priceController.text.trim(),
              'description': descriptionController.text.trim(),
              'date': _selectedDateLocal,
              'startTime': _selectedStartTimeLocal,
              'endTime': _selectedEndTimeLocal,
              'sellerName':
                  SessionController().authModel.response.user.name ??
                  'Photographer',
              'consumerName':
                  SessionController().authModel.response.user.name ??
                  'Photographer',
              'consumerId': SessionController().authModel.response.user.id,
              'serviceType': 'Photography Service',
            },
          });

          // Fallback navigation if the above doesn't work
          Future.delayed(const Duration(milliseconds: 100), () {
            if (mounted && Navigator.canPop(context)) {
              print('🔄 Fallback navigation...');
              Navigator.pop(context, true);
            }
          });
        } else {
          print('❌ Widget not mounted after offer creation');
        }
      } else {
        print('❌ Unexpected response status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('❌ DioException caught:');
      print('  - Type: ${e.type}');
      print('  - Message: ${e.message}');
      print('  - Response: ${e.response?.data}');
      print('  - Status code: ${e.response?.statusCode}');

      String errorMessage =
          e.response?.data['message'] ?? 'Failed to create offer';

      // Truncate long error messages to prevent UI overflow
      if (errorMessage.length > 200) {
        errorMessage = errorMessage.substring(0, 200) + '...';
      }

      // Show error message after current frame to avoid navigator lock
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Utils.flushBarErrorMessage(errorMessage, context);
        });
      }
    } catch (e, stackTrace) {
      print('❌ General error caught:');
      print('  - Error: $e');
      print('  - Stack trace: $stackTrace');

      String errorMessage = 'Failed to create offer: $e';

      // Truncate long error messages to prevent UI overflow
      if (errorMessage.length > 200) {
        errorMessage = errorMessage.substring(0, 200) + '...';
      }

      // Show error message after current frame to avoid navigator lock
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Utils.flushBarErrorMessage(errorMessage, context);
        });
      }
    } finally {
      print('🏁 API call finished, setting loading to false');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  bool _validateForm() {
    if (locationController.text.trim().isEmpty) {
      Utils.flushBarErrorMessage('Please enter location', context);
      return false;
    }
    if (priceController.text.trim().isEmpty) {
      Utils.flushBarErrorMessage('Please enter price', context);
      return false;
    }
    if (descriptionController.text.trim().isEmpty) {
      Utils.flushBarErrorMessage('Please enter description', context);
      return false;
    }
    if (_selectedDateLocal == null) {
      Utils.flushBarErrorMessage('Please select date', context);
      return false;
    }
    if (_selectedStartTimeLocal == null) {
      Utils.flushBarErrorMessage('Please select time', context);
      return false;
    }
    if (_selectedEndTimeLocal == null) {
      Utils.flushBarErrorMessage('Please select time', context);
      return false;
    }
    return true;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFiles.add(File(pickedFile.path));
      });
    }
  }

  @override
  void dispose() {
    locationController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: const CustomAppBar(title: 'Create an Offer'),
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
                      text: 'Location\'s Address',
                      fontSized: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                      alignment: TextAlign.start,
                    ),
                    SizedBox(height: 8.w),
                    TextField(
                      controller: locationController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 15.w,
                        ),
                        hintText: 'Enter location\'s address',
                        hintStyle: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Nunito Sans',
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
                      text: 'Service Date',
                      fontSized: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                      alignment: TextAlign.start,
                    ),
                    SizedBox(height: 8.w),
                    TextField(
                      controller: TextEditingController(
                        text: _selectedDateLocal,
                      ),
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          final localValue =
                              pickedDate.toUtc().toIso8601String();
                          setState(() {
                            _selectedDate = localValue;
                            _selectedDateLocal = DateFormat(
                              'yyyy-MM-dd',
                            ).format(pickedDate);
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
                        hintText: 'Select date',
                        hintStyle: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Nunito Sans',
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
                      text: 'Delivery Date',
                      fontSized: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                      alignment: TextAlign.start,
                    ),
                    SizedBox(height: 8.w),
                    TextField(
                      controller: TextEditingController(
                        text: _selectedDueDateLocal,
                      ),
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          final localValue =
                              pickedDate.toUtc().toIso8601String();
                          setState(() {
                            _selectedDueDate = localValue;
                            _selectedDueDateLocal = DateFormat(
                              'yyyy-MM-dd',
                            ).format(pickedDate);
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
                        hintText: 'Select date',
                        hintStyle: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Nunito Sans',
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
                      text: 'Start Time',
                      fontSized: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                      alignment: TextAlign.start,
                    ),
                    SizedBox(height: 8.w),
                    TextField(
                      controller: TextEditingController(
                        text: _selectedStartTime,
                      ),
                      readOnly: true,
                      onTap: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          final now = DateTime.now();
                          final pickedDateTime = DateTime(
                            now.year,
                            now.month,
                            now.day,
                            pickedTime.hour,
                            pickedTime.minute,
                          );
                          final localValue =
                              pickedDateTime.toUtc().toIso8601String();
                          setState(() {
                            _selectedStartTime = pickedTime.format(context);
                            _selectedStartTimeLocal = localValue;
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
                            image: const AssetImage('assets/images/timer.png'),
                          ),
                        ),
                        hintText: '00:00',
                        hintStyle: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Nunito Sans',
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
                      text: 'End Time',
                      fontSized: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                      alignment: TextAlign.start,
                    ),
                    SizedBox(height: 8.w),
                    TextField(
                      controller: TextEditingController(text: _selectedEndTime),
                      readOnly: true,
                      onTap: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          final now = DateTime.now();
                          final pickedDateTime = DateTime(
                            now.year,
                            now.month,
                            now.day,
                            pickedTime.hour,
                            pickedTime.minute,
                          );
                          final localValue =
                              pickedDateTime.toUtc().toIso8601String();
                          setState(() {
                            _selectedEndTime = pickedTime.format(context);
                            _selectedEndTimeLocal = localValue;
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
                            image: const AssetImage('assets/images/timer.png'),
                          ),
                        ),
                        hintText: '00:00',
                        hintStyle: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Nunito Sans',
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
                      text: 'Set Price',
                      fontSized: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                      alignment: TextAlign.start,
                    ),
                    SizedBox(height: 8.w),
                    TextField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
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
                            image: const AssetImage('assets/images/money.png'),
                          ),
                        ),
                        hintText: 'Price',
                        hintStyle: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Nunito Sans',
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
                      text: 'Description',
                      fontSized: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                      alignment: TextAlign.start,
                    ),
                    SizedBox(height: 8.w),
                    TextField(
                      controller: descriptionController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 15.w,
                        ),
                        hintText: 'Describe your offer...',
                        hintStyle: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Nunito Sans',
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
                    TextField(
                      controller: notesController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 15.w,
                        ),
                        hintText: 'Additional Notes',
                        hintStyle: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Nunito Sans',
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
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.w),
                      child: const CustomText(
                        text: 'Pictures Delivery',
                        fontSized: 14.0,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackColor,
                        alignment: TextAlign.left,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 70.w,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              width: 70.w,
                              height: 70.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: const DecorationImage(
                                  image: AssetImage(
                                    'assets/images/dot_border.png',
                                  ),
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
                            child: ListView.builder(
                              itemCount: imageFiles.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.only(right: 10.w),
                                  width: 70.w,
                                  height: 70.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: FileImage(imageFiles[index]),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        top: 5,
                                        right: 5,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              imageFiles.removeAt(index);
                                            });
                                          },
                                          child: Container(
                                            width: 20.w,
                                            height: 20.w,
                                            decoration: const BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    CustomButton(
                      loading: isLoading,
                      title: 'Send an Offer',
                      onPressed: _createOfferApi,
                      btnColor: AppColors.backgroundColor,
                      btnTextColor: AppColors.whiteColor,
                    ),
                    const SizedBox(height: 20),
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
