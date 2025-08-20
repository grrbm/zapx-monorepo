import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/view/authentication/forgot_password/send_code_screen.dart';
import 'package:zapxx/view/authentication/widgets/auth_input_text_field.dart';
import 'package:zapxx/view/authentication/widgets/welcome_title.dart';
import 'package:zapxx/view/login/widgets/login_button_widget.dart';
import 'package:provider/provider.dart';
import 'package:zapxx/view_model/user_view_model.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _areYouPhotographer = false;
  @override
  Widget build(BuildContext context) {
    final loginViewModel = Provider.of<UserViewModel>(context, listen: false);
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
                    title: 'Sign In',
                    subTitle: 'Welcome back',
                    crossAxisAlignment: CrossAxisAlignment.center,
                    textAlign: TextAlign.center,
                    topPadding: 62.h,
                  ),
                ),
                SizedBox(height: 32.h),
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
                    loginViewModel.setEmail(value);
                  },
                ),
                SizedBox(height: 20.h),
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
                    loginViewModel.setPassword(value);
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top: 11.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SendCodeScreen(),
                              ),
                            );
                          },
                          child: CustomText(
                            text: 'Forgot Password?',
                            fontSized: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.backgroundColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25.h),
                LoginButtonWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
