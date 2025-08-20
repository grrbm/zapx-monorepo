import 'package:flutter/material.dart';

import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/view_model/services/splash/splash_services.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  SplashServices splashServices = SplashServices();

  @override
  void initState() {
    super.initState();

    splashServices.checkAuthentication(context);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: CustomText(
          text: 'ZAPX',
          fontSized: 54.0,
          fontWeight: FontWeight.bold,
          color: AppColors.whiteColor,
        ),
      ),
    );
  }
}
