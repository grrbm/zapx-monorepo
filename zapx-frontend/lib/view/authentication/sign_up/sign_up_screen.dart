import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:provider/provider.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_button.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/view/authentication/registration/choose_your_service_screen.dart';
import 'package:zapxx/view/authentication/sign_up/widgets/signup_button.dart';
import 'package:zapxx/view/authentication/widgets/auth_input_text_field.dart';
import 'package:zapxx/view/authentication/widgets/welcome_title.dart';
import 'package:zapxx/view/nav_bar/user/user_nav_bar.dart';
import 'package:zapxx/view_model/signup/signup_view_model.dart';
import 'package:zapxx/view_model/user_view_model.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _areYouPhotographer = false;
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    final signupViewModel = Provider.of<UserViewModel>(context, listen: false);
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
        ),
        child: Scaffold(
          backgroundColor: AppColors.whiteColor,
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: WelcomeTitle(
                      title: 'Sign Up',
                      subTitle: 'Create account',
                      crossAxisAlignment: CrossAxisAlignment.center,
                      textAlign: TextAlign.center,
                      topPadding: 62.h,
                    ),
                  ),
                  SizedBox(
                    height: 32.h,
                  ),
                  CustomPoppinText(
                    text: 'Full Name',
                    color: AppColors.blackColor,
                    fontSized: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  AuthInputTextField(
                    hintText: 'Enter your name',
                    prefixIcon: 'assets/images/profile.png',
                    isObscureText: false,
                    controller: _nameController,
                    textInputType: TextInputType.text,
                    onChanged: (value) {
                      signupViewModel.setUsername(value);
                    },
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  CustomPoppinText(
                    text: 'Email',
                    color: AppColors.blackColor,
                    fontSized: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  AuthInputTextField(
                    hintText: 'Enter your email',
                    prefixIcon: 'assets/images/sms.png',
                    isObscureText: false,
                    controller: _emailController,
                    textInputType: TextInputType.emailAddress,
                    onChanged: (value) {
                      signupViewModel.setEmail(value);
                    },
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  CustomPoppinText(
                    text: 'Password',
                    color: AppColors.blackColor,
                    fontSized: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  AuthInputTextField(
                    hintText: 'Enter your password',
                    prefixIcon: 'assets/images/lock.png',
                    isObscureText: true,
                    controller: _passwordController,
                    textInputType: TextInputType.text,
                    onChanged: (value) {
                      signupViewModel.setPassword(value);
                    },
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  CustomPoppinText(
                    text: 'Confirm Password',
                    color: AppColors.blackColor,
                    fontSized: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  AuthInputTextField(
                    hintText: 'Enter your password',
                    prefixIcon: 'assets/images/lock.png',
                    isObscureText: true,
                    controller: _confirmPasswordController,
                    textInputType: TextInputType.text,
                    onChanged: (value) {
                      signupViewModel.setConfirmPassword(value);
                    },
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      SizedBox(
                        height: 24.h,
                        width: 24.w,
                        child: Padding(
                          padding: EdgeInsets.zero,
                          child: Checkbox(
                            value: _areYouPhotographer,
                            onChanged: (bool? newValue) {
                              setState(() {
                                _areYouPhotographer = newValue!;
                              });
                              signupViewModel
                                  .setAreYouPhotographer(newValue ?? false);
                              signupViewModel
                                  .setRole(newValue! ? 'SELLER' : 'CONSUMER');
                            },
                            side: const BorderSide(
                              color: AppColors.greyColor,
                            ),
                            activeColor: AppColors.backgroundColor,
                            checkColor: AppColors.whiteColor,
                          ),
                        ),
                      ),
                      CustomText(
                        text: 'Are you a Photographer',
                        fontSized: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackColor,
                      ),
                    ],
                  ),
                  SizedBox(height: 40.h),
                  const SignupButtonWidget(),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ),
        ));
  }
}
