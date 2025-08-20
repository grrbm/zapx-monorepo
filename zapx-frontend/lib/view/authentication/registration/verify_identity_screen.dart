import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapxx/configs/app_url.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_app_bar.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_button.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/configs/utils.dart';
import 'package:zapxx/view/authentication/widgets/welcome_title.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:zapxx/view/nav_bar/photographer/nav_bar.dart';
import 'package:zapxx/view_model/services/session_manager/session_controller.dart';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';

class VerifyIdentityScreen extends StatefulWidget {
  final List<int> selectedServiceIds;
  final int categoryId;
  const VerifyIdentityScreen({
    super.key,
    required this.selectedServiceIds,
    required this.categoryId,
  });

  @override
  State<VerifyIdentityScreen> createState() => _VerifyIdentityScreenState();
}

class _VerifyIdentityScreenState extends State<VerifyIdentityScreen> {
  File? _image;
  File? _imageCard;
  final picker = ImagePicker();
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _pickCardImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    setState(() {
      if (pickedFile != null) {
        _imageCard = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  bool loading = false;
  Future<void> _uploadImage() async {
    setState(() {
      loading = true;
    });
    if (_image == null || _imageCard == null) {
      Utils.flushBarErrorMessage('Both images are required', context);
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
        MapEntry(
          'cardImage',
          await MultipartFile.fromFile(
            _imageCard!.path,
            filename: _imageCard!.path.split('/').last,
            contentType: MediaType('image', 'jpeg'),
          ),
        ),
      ]);

      formData.fields.addAll([
        MapEntry('services', jsonEncode(widget.selectedServiceIds)),
        MapEntry('categoryId', widget.categoryId.toString()),
      ]);

      print('FormData: ${formData.fields}');
      print('Files: ${formData.files}');

      final response = await dio.post(
        AppUrl.profileEndPoint,
        data: formData,
        options: Options(
          headers: {'Authorization': token, 'Accept': 'application/json'},
          contentType: 'multipart/form-data',
        ),
      );

      print('Upload response: ${response.data}');
      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (context) => const CustomverifyDialogBox(),
        );
        await Future.delayed(const Duration(seconds: 3));
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PhotographerNavBar()),
        );
        setState(() {
          loading = false;
        });
      }
    } on DioException catch (e) {
      print('Upload error: ${e.response?.data}');
      Utils.flushBarErrorMessage(
        e.response?.data['message'] ?? 'Upload failed',
        context,
      );
      setState(() {
        loading = false;
      });
    } catch (e) {
      print('General error: $e');
      Utils.flushBarErrorMessage('Upload failed: $e', context);
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: const CustomAppBar(
        title: 'Verify Identity',
        backgroundColor: AppColors.whiteColor,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 333.w,
                child: WelcomeTitle(
                  title: 'Upload a photo of your National ID Card 🪪',
                  subTitle:
                      'Regulations require you to upload a national identity card. Don\'t worry, your data will stay safe and private.',
                  crossAxisAlignment: CrossAxisAlignment.start,
                  textAlign: TextAlign.left,
                  topPadding: 36.w,
                ),
              ),
              SizedBox(height: 28.w),
              GestureDetector(
                onTap: () {
                  _pickImage(ImageSource.gallery);
                },
                child: Container(
                  width: 333.w,
                  height: 209.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28.r),
                    border: Border.all(
                      color: AppColors.backgroundColor,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_image != null)
                          Image.file(
                            _image!,
                            width: 160.w,
                            height: 120.w,
                            fit: BoxFit.cover,
                          )
                        else
                          Image(
                            width: 25.w,
                            height: 25.w,
                            color: AppColors.greyColor1,
                            image: const AssetImage('assets/images/photo.png'),
                          ),
                        SizedBox(height: 13.w),
                        CustomText(
                          text: 'Select front side',
                          fontSized: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.greyColor1,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 27.w),
                child: SizedBox(
                  width: 333.w,
                  child: Row(
                    children: [
                      const Expanded(child: Divider(endIndent: 10)),
                      CustomText(
                        text: 'and',
                        fontSized: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.blackColor,
                      ),
                      const Expanded(child: Divider(indent: 10)),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _pickCardImage(ImageSource.gallery);
                },
                child: Container(
                  width: 333.w,
                  height: 209.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28.r),
                    border: Border.all(
                      color: AppColors.backgroundColor,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_imageCard != null)
                          Image.file(
                            _imageCard!,
                            width: 160.w,
                            height: 120.w,
                            fit: BoxFit.cover,
                          )
                        else
                          Image(
                            width: 25.w,
                            height: 25.w,
                            color: AppColors.greyColor1,
                            image: const AssetImage('assets/images/photo.png'),
                          ),
                        SizedBox(height: 13.w),
                        CustomText(
                          text: 'Select back side',
                          fontSized: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.greyColor1,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40.w),
              CustomButton(
                loading: loading,
                title: 'Continue',
                onPressed: () {
                  _uploadImage();
                },
                btnColor: AppColors.backgroundColor,
                btnTextColor: AppColors.whiteColor,
              ),
              SizedBox(height: 20.w),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomverifyDialogBox extends StatelessWidget {
  const CustomverifyDialogBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(36)),
      ),
      backgroundColor: AppColors.whiteColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          20.verticalSpace,
          Container(
            height: 400.0, // Custom height
            width: 330.0, // Custom width
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              color: AppColors.whiteColor,
            ),
            child: Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/image_verify.png',
                    height: 150.h,
                    width: 150.w,
                  ),
                  SizedBox(height: 10.w),
                  CustomText(
                    text: 'Verification Successful!',
                    fontSized: 19.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.backgroundColor,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 40.w,
                      vertical: 10.w,
                    ),
                    child: CustomText(
                      text:
                          'Your account has been verified.Please wait a moment, we are preparing for you...',
                      fontSized: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.backgroundColor,
                    ),
                  ),
                  SizedBox(height: 10.w),
                  const CupertinoActivityIndicator(
                    color: AppColors.backgroundColor,
                    radius: 25,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
