import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapxx/configs/app_url.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_button.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/configs/utils.dart';
import 'package:zapxx/model/user/consumer_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zapxx/view_model/services/session_manager/session_controller.dart';
import 'package:http_parser/http_parser.dart';
import 'package:provider/provider.dart';
import 'package:zapxx/view_model/user_view_model.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
    super.key,
    required this.userConsumer,
    required this.email,
  });
  final UserConsumer userConsumer;
  final String email;
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? _image;
  final picker = ImagePicker();
  bool _isLoading = false;
  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _updateProfile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _updateProfile() async {
    if (_image == null) {
      Utils.flushBarErrorMessage('Image is required', context);
      return;
    }

    try {
      final dio = Dio(BaseOptions(baseUrl: AppUrl.baseUrl));
      final token = SessionController().authModel.response.token;

      final formData = FormData();

      formData.files.addAll([
        MapEntry(
          'image',
          await MultipartFile.fromFile(
            _image!.path,
            filename: _image!.path.split('/').last,
            contentType: MediaType('image', 'jpeg'),
          ),
        ),
      ]);

      // formData.fields.addAll([
      //   MapEntry('services', jsonEncode(widget.selectedServiceIds)),
      //   MapEntry('categoryId', widget.categoryId.toString()),
      // ]);

      print('FormData: ${formData.fields}');
      print('Files: ${formData.files}');

      final response = await dio.post(
        AppUrl.profileImage,
        data: formData,
        options: Options(
          headers: {'Authorization': token, 'Accept': 'application/json'},
          contentType: 'multipart/form-data',
        ),
      );

      print('Upload response: ${response.data}');
      if (response.statusCode == 200) {}
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
    final userProvider = Provider.of<UserViewModel>(context, listen: false);
    late final TextEditingController controllerName = TextEditingController(
      text: widget.userConsumer.fullName,
    );
    late final TextEditingController controllerUserName = TextEditingController(
      text: widget.userConsumer.username,
    );
    late final TextEditingController controllerPhone = TextEditingController(
      text: widget.userConsumer.consumer?.phone ?? '+234 000 000 0000',
    );
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
          text: 'Edit Profile',
          fontSized: 18.0,
          fontWeight: FontWeight.w600,
          color: AppColors.blackColor,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(thickness: 1),
            SizedBox(height: 39.h),
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 120.h,
                    height: 120.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image:
                          widget.userConsumer.profileImage == null
                              ? const DecorationImage(
                                image: AssetImage(
                                  'assets/images/profile_picture.png',
                                ),
                                fit: BoxFit.cover,
                              )
                              : DecorationImage(
                                image: NetworkImage(
                                  AppUrl.baseUrl +
                                      '/' +
                                      widget.userConsumer.profileImage!.url,
                                ),
                                fit: BoxFit.cover,
                              ),
                    ),
                  ),
                  Positioned(
                    top: 52.h,
                    left: 43.h,
                    child: InkWell(
                      onTap: () {
                        _pickImage();
                      },
                      child: Image(
                        width: 34.h,
                        height: 34.h,
                        image: const AssetImage('assets/images/camera.png'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 46.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomPoppinText(
                    text: 'Full Name',
                    fontSized: 14.0,
                    color: AppColors.blackColor,
                    alignment: TextAlign.left,
                  ),
                  SizedBox(height: 8.h),
                  EditProfileTextField(
                    controller: controllerName,
                    hintText: widget.userConsumer.fullName!,
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 16.h),
                  const CustomPoppinText(
                    text: 'Username',
                    fontSized: 14.0,
                    color: AppColors.blackColor,
                    alignment: TextAlign.left,
                  ),
                  SizedBox(height: 8.h),
                  EditProfileTextField(
                    controller: controllerUserName,
                    hintText: widget.userConsumer.username!,
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 16.h),
                  const CustomPoppinText(
                    text: 'Email',
                    fontSized: 14.0,
                    color: AppColors.blackColor,
                    alignment: TextAlign.left,
                  ),
                  SizedBox(height: 8.h),
                  EditProfileTextField(
                    hintText: widget.email,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 16.h),
                  const CustomPoppinText(
                    text: 'Phone',
                    fontSized: 14.0,
                    color: AppColors.blackColor,
                    alignment: TextAlign.left,
                  ),
                  SizedBox(height: 8.h),
                  EditProfileTextField(
                    controller: controllerPhone,
                    hintText:
                        widget.userConsumer.consumer!.phone == null
                            ? '+234 000 000 0000'
                            : widget.userConsumer.consumer!.phone!,
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 26.h),
                  CustomButton(
                    loading: userProvider.loading,
                    title: 'Save Changes',
                    onPressed: () async {
                      Map data = {
                        "fullName": controllerName.text,
                        "username": controllerUserName.text,
                        "phone": controllerPhone.text,
                      };

                      try {
                        await userProvider.updateProfile(data);
                        if (mounted) {
                          // Use a simpler success message approach
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('User Updated Successfully'),
                              backgroundColor: Colors.green,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                          // Navigate back after a short delay
                          Future.delayed(
                            const Duration(milliseconds: 1000),
                            () {
                              if (mounted) {
                                Navigator.pop(context);
                              }
                            },
                          );
                        }
                      } catch (error) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(error.toString()),
                              backgroundColor: Colors.red,
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        }
                      }
                    },
                    btnColor: AppColors.backgroundColor,
                    btnTextColor: AppColors.whiteColor,
                  ),
                  SizedBox(height: 56.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditProfileTextField extends StatelessWidget {
  final String hintText;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  EditProfileTextField({
    super.key,
    required this.hintText,
    required this.keyboardType,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(
        color: AppColors.blackColor,
        fontSize: 14.sp,
        fontFamily: 'nunito sans',
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: AppColors.greyColor.withOpacity(0.5),
          fontSize: 14.sp,
          fontFamily: 'nunito sans',
        ),
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
