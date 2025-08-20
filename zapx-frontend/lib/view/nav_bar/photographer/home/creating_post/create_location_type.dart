import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_button.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/controller/post_controller.dart';

import '../../../../../configs/app_url.dart';
import '../../../../../configs/utils.dart';
import '../../../../../view_model/services/session_manager/session_controller.dart';

class CreateLocationType extends StatefulWidget {
  const CreateLocationType({super.key});
  @override
  State<CreateLocationType> createState() => _CreateLocationTypeState();
}

class _CreateLocationTypeState extends State<CreateLocationType> {
  bool _isLoading = false;
  Future<void> createLocation() async {
    try {
      final dio = Dio(BaseOptions(baseUrl: AppUrl.baseUrl));
      final token = SessionController().authModel.response.token;

      setState(() {
        _isLoading = true;
      });

      // Prepare the JSON body
      final Map<String, dynamic> requestBody = {
        "name": Get.find<PostController>().locationTypeCtrl.text,
      };

      logger.i(requestBody);

      final response = await dio.post(
        AppUrl.getLocation, // Replace with your API endpoint
        data: requestBody,
        options: Options(
          headers: {
            'Authorization': token,
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        logger.i(response.data);
        setState(() {
          _isLoading = false;
        });
        Get.back();
        Utils.flushBarSuccessMessage('Location created successfully!', context);

        Get.find<PostController>().locationTypeCtrl.clear();
        await Get.find<PostController>().fetchLocationType();
        Get.find<PostController>().update();

        // Optionally, you can navigate back or show a success message
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Please try again.')));
      }
    } on DioException catch (e) {
      print('Upload error: ${e.response?.data}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.response?.data['message'] ?? 'Failed')),
      );
    } catch (e) {
      print('General error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
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
          text: 'Add Location Type',
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
            SizedBox(height: 46.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),
                  const CustomPoppinText(
                    text: 'Location Type',
                    fontSized: 14.0,
                    color: AppColors.blackColor,
                    alignment: TextAlign.left,
                  ),
                  SizedBox(height: 8.h),
                  EditProfileTextField(
                    controller: Get.find<PostController>().locationTypeCtrl,
                    hintText: '',
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 26.h),
                  CustomButton(
                    loading: _isLoading,
                    title: 'Save Changes',
                    onPressed: () {
                      createLocation();
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
  final int? maxLines;
  EditProfileTextField({
    super.key,
    required this.hintText,
    required this.keyboardType,
    this.controller,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: maxLines,
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
