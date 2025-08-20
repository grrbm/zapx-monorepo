import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapxx/configs/color/color.dart';

import 'package:zapxx/configs/custom_global_widgets/custom_button.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/view/authentication/sign_in/sign_in_screen.dart';
import 'package:zapxx/view/authentication/sign_up/sign_up_screen.dart';

class ChooseAuthScreen extends StatelessWidget {
  const ChooseAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.whiteColor,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                  padding: EdgeInsets.only(top: 131.h),
                  child: CustomText(
                    text: 'Welcome to ZapX',
                    color: AppColors.blackColor,
                    fontSized: 24.sp,
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(
                height: 8,
              ),
              CustomText(
                text: 'Choose how you want to continue',
                alignment: TextAlign.center,
                color: AppColors.greyColor,
                fontSized: 16.sp,
                fontWeight: FontWeight.normal,
              ),
              const Spacer(),
              CustomButton(
                title: 'I\'m a new user',
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpScreen()));
                },
                btnColor: AppColors.whiteColor,
                btnTextColor: AppColors.backgroundColor,
              ),
              SizedBox(
                height: 20.h,
              ),
              CustomButton(
                title: 'Sign In',
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignInScreen()));
                },
                btnColor: AppColors.backgroundColor,
                btnTextColor: AppColors.whiteColor,
              ),
              SizedBox(
                height: 10.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
