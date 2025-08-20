import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/utils.dart';
import 'package:zapxx/view/authentication/forgot_password/new_password_screen.dart';
import 'package:zapxx/view/authentication/widgets/welcome_title.dart';
import 'package:zapxx/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key, required this.email});
  final email;
  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserViewModel>(context, listen: false);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.whiteColor,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: WelcomeTitle(
                title: 'Enter your code',
                subTitle:
                    'we have sent a verification code to email ${widget.email}',
                crossAxisAlignment: CrossAxisAlignment.start,
                textAlign: TextAlign.start,
                topPadding: 86.h,
              ),
            ),
            SizedBox(
              height: 16.h,
            ),
            OtpTextField(
              numberOfFields: 4,
              fieldWidth: 74.w,
              fieldHeight: 54.h,
              keyboardType: TextInputType.number,
              textStyle: const TextStyle(color: AppColors.blackColor),
              borderColor: AppColors.backgroundColor,
              showFieldAsBox: true,
              onCodeChanged: (String code) {
                //handle validation or checks here
              },
              //runs when every textfield is filled
              onSubmit: (String verificationCode) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          "Verification Code",
                          style: TextStyle(
                            color: AppColors.greyColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        content: Text(
                          'Code entered is $verificationCode',
                          style: TextStyle(
                            color: AppColors.greyColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Map data = {
                                  'otp': verificationCode,
                                };
                                userProvider.verifyOtp(data).then((value) {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              NewPasswordScreen(
                                                email: widget.email,
                                              )));
                                }).onError((error, stackTrace) {
                                  Utils.flushBarErrorMessage(
                                      error.toString(), context);
                                });
                              },
                              child: const Text('Next'))
                        ],
                      );
                    });
              },
            ),
            Padding(
              padding: EdgeInsets.only(left: 24.w, top: 8.h),
              child: Text(
                'Send code reload in 0:15',
                style: TextStyle(
                  color: AppColors.greyColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
