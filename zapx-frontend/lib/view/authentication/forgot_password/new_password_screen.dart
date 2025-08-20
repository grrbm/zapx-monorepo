import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_button.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/configs/utils.dart';
import 'package:zapxx/view/authentication/sign_in/sign_in_screen.dart';
import 'package:zapxx/view/authentication/widgets/auth_input_text_field.dart';
import 'package:zapxx/view/authentication/widgets/welcome_title.dart';
import 'package:provider/provider.dart';
import 'package:zapxx/view_model/user_view_model.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key, required this.email});
  final String email;
  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

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
                        title: 'Enter new password',
                        subTitle: 'Please enter your new password',
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
                    text: 'Password',
                    color: AppColors.blackColor,
                    fontSized: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  AuthInputTextField(
                    hintText: 'Enter your password',
                    prefixIcon: 'assets/images/sms.png',
                    isObscureText: false,
                    controller: _passwordController,
                    textInputType: TextInputType.text,
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
                    hintText: 'Enter your confirm password',
                    prefixIcon: 'assets/images/lock.png',
                    isObscureText: false,
                    controller: _confirmPasswordController,
                    textInputType: TextInputType.text,
                  ),
                  SizedBox(
                    height: 154.h,
                  ),
                  CustomButton(
                    loading: userProvider.loading ? true : false,
                    title: 'Sign In',
                    btnColor: AppColors.backgroundColor,
                    btnTextColor: AppColors.whiteColor,
                    onPressed: () {
                      Map data = {
                        'password': _confirmPasswordController.text,
                        'email': widget.email,
                      };
                      userProvider.newPassword(data).then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignInScreen()));
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
