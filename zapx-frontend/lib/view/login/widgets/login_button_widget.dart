import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_button.dart';
import 'package:zapxx/model/user/auth_model.dart';
import 'package:zapxx/view/nav_bar/photographer/nav_bar.dart';
import 'package:zapxx/view/nav_bar/user/user_nav_bar.dart';
import 'package:zapxx/view_model/services/session_manager/session_controller.dart';
import 'package:zapxx/view_model/user_view_model.dart';
import '../../../configs/utils.dart';
import '../../../configs/validator/app_validator.dart';

class LoginButtonWidget extends StatelessWidget {
  const LoginButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserViewModel>(
      builder: (context, provider, child) {
        return CustomButton(
          btnColor: AppColors.backgroundColor,
          btnTextColor: AppColors.whiteColor,
          title: 'Login',
          loading: provider.loading ? true : false,
          onPressed: () {
            if (provider.email.isEmpty) {
              Utils.flushBarErrorMessage('Please enter email', context);
            } else if (!AppValidator.emailValidator(
              provider.email.toString(),
            )) {
              Utils.flushBarErrorMessage('Please enter valid email', context);
            } else if (provider.password.isEmpty) {
              Utils.flushBarErrorMessage('Please enter password', context);
            } else if (provider.password.length < 6) {
              Utils.flushBarErrorMessage(
                'Please enter 6 digit password',
                context,
              );
            } else {
              Map data = {
                'email': provider.email.toString(),
                'password': provider.password.toString(),
              };

              // Map data = {
              //   'email' : 'eve.holt@reqres.in',
              //   'password' : 'cityslicka',
              // };

              provider
                  .loginUser(data)
                  .then((value) async {
                    AuthModelResponse authModel = value;

                    authModel.response.user.role == 'SELLER'
                        ? Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PhotographerNavBar(),
                          ),
                        )
                        : Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UserNavBar(),
                          ),
                        );
                  })
                  .onError((error, stackTrace) {
                    Utils.flushBarErrorMessage(error.toString(), context);
                  });
            }
          },
        );
      },
    );
  }
}
