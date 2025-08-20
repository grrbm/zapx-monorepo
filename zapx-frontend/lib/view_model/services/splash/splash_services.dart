import 'dart:async';
import 'package:flutter/material.dart';
import 'package:zapxx/view/authentication/welcome/choose_auth_screen.dart';
import 'package:zapxx/view/nav_bar/photographer/nav_bar.dart';
import 'package:zapxx/view/nav_bar/user/user_nav_bar.dart';
import 'package:zapxx/view_model/services/session_manager/session_controller.dart';

class SplashServices {
  void checkAuthentication(BuildContext context) async {
    SessionController().getAuthModelFromPreference().then((value) async {
      if (SessionController().isLogin!) {
        Timer(
            const Duration(seconds: 2),
            () => SessionController().authModel.response.user.role == 'SELLER'
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
                  ));
      } else {
        Timer(
          const Duration(seconds: 2),
          () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ChooseAuthScreen())),
        );
      }
    }).onError((error, stackTrace) {
      Timer(
        const Duration(seconds: 2),
        () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ChooseAuthScreen())),
      );
    });
  }
}
