import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_button.dart';
import 'package:zapxx/configs/utils.dart';
import 'package:zapxx/configs/validator/app_validator.dart';
import 'package:zapxx/view/authentication/registration/choose_your_service_screen.dart';
import 'package:zapxx/view/nav_bar/user/user_nav_bar.dart';
import 'package:zapxx/view_model/user_view_model.dart';

class SignupButtonWidget extends StatelessWidget {
  const SignupButtonWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<UserViewModel>(builder: (context, provider, child) {
      return CustomButton(
        loading: provider.loading,
        title: 'Sign Up',
        btnColor: AppColors.backgroundColor,
        btnTextColor: AppColors.whiteColor,
        onPressed: () {
          if (provider.email.isEmpty) {
            Utils.flushBarErrorMessage('Please enter email', context);
          } else if (!AppValidator.emailValidator(provider.email.toString())) {
            Utils.flushBarErrorMessage('Please enter valid email', context);
          } else if (provider.password.isEmpty) {
            Utils.flushBarErrorMessage('Please enter password', context);
          } else if (provider.password.length < 6) {
            Utils.flushBarErrorMessage(
                'Please enter 6 digit password', context);
          } else if (provider.confirmPassword.isEmpty) {
            Utils.flushBarErrorMessage('Please confirm your password', context);
          } else if (provider.password != provider.confirmPassword) {
            Utils.flushBarErrorMessage('Passwords do not match', context);
          } else {
            Map data = {
              'fullName': provider.username.toString(),
              'email': provider.email.toString(),
              'password': provider.password.toString(),
              'role': provider.role.toString()
            };

            provider.signupUser(data).then((value) {
              String role = value.response.user.role;
              role == 'SELLER'
                  ? Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const ChooseYourServiceScreen()))
                  : Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UserNavBar()));
            }).onError((error, stackTrace) {
              Utils.flushBarErrorMessage(error.toString(), context);
            });
          }
        },
      );
    });
  }
}
