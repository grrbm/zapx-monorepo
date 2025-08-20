import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_button.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/configs/utils.dart';
import 'package:zapxx/view/authentication/forgot_password/otp_screen.dart';
import 'package:zapxx/view/authentication/widgets/auth_input_text_field.dart';
import 'package:zapxx/view/authentication/widgets/welcome_title.dart';
import 'package:zapxx/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

class SendCodeScreen extends StatefulWidget {
  const SendCodeScreen({super.key});

  @override
  State<SendCodeScreen> createState() => _SendCodeScreenState();
}

class _SendCodeScreenState extends State<SendCodeScreen> {
  final TextEditingController _emailController = TextEditingController();

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
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: WelcomeTitle(
                        title: 'Forgot Password',
                        subTitle:
                            'Please enter your email to recover your account',
                        crossAxisAlignment: CrossAxisAlignment.center,
                        textAlign: TextAlign.center,
                        topPadding: 62.h,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 47.h,
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
                      textInputType: TextInputType.emailAddress),
                  SizedBox(
                    height: 154.h,
                  ),
                  CustomButton(
                    loading: userProvider.loading ? true : false,
                    title: 'Send Code',
                    btnColor: AppColors.backgroundColor,
                    btnTextColor: AppColors.whiteColor,
                    onPressed: () {
                      Map data = {
                        'email': _emailController.text,
                      };
                      userProvider.forgotpassword(data).then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OTPScreen(
                                      email: _emailController.text,
                                    )));
                      }).onError((error, stackTrace) {
                        Utils.flushBarErrorMessage(error.toString(), context);
                      });
                    },
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
