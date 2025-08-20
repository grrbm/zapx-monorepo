import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_button.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/repository/auth_api/auth_http_api_repository.dart';
import 'package:zapxx/repository/auth_api/auth_repository.dart';
import 'package:zapxx/view/authentication/registration/choose_services_screen.dart';
import 'package:zapxx/view/authentication/widgets/welcome_title.dart';

class ChooseYourServiceScreen extends StatefulWidget {
  const ChooseYourServiceScreen({super.key});

  @override
  State<ChooseYourServiceScreen> createState() =>
      _ChooseYourServiceScreenState();
}

class _ChooseYourServiceScreenState extends State<ChooseYourServiceScreen> {
  bool isPhotography = false;
  bool isVideography = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 270.w,
              child: WelcomeTitle(
                  title: 'Choose your service',
                  subTitle:
                      'Please choose your service which you want to offer',
                  crossAxisAlignment: CrossAxisAlignment.center,
                  textAlign: TextAlign.center,
                  topPadding: 36.w),
            ),
            SizedBox(
              height: 36.w,
            ),
            SizedBox(
              width: 270.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isPhotography = !isPhotography;
                        if (isPhotography) {
                          isVideography = false;
                        }
                      });
                    },
                    child: Container(
                      width: 84.w,
                      height: 84.w,
                      decoration: BoxDecoration(
                        color: isPhotography
                            ? AppColors.backgroundColor
                            : AppColors.backgroundColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(100.r),
                      ),
                      child: Center(
                          child: Image(
                              width: 30.w,
                              height: 30.w,
                              color: AppColors.whiteColor,
                              image: AssetImage(isPhotography
                                  ? 'assets/images/check.png'
                                  : 'assets/images/camera.png'))),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isVideography = !isVideography;
                        if (isVideography) {
                          isPhotography = false;
                        }
                      });
                    },
                    child: Container(
                      width: 84.w,
                      height: 84.w,
                      decoration: BoxDecoration(
                        color: isVideography
                            ? AppColors.backgroundColor
                            : AppColors.backgroundColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(100.r),
                      ),
                      child: Center(
                          child: Image(
                              width: 37.w,
                              height: 37.w,
                              color: AppColors.whiteColor,
                              image: AssetImage(isVideography
                                  ? 'assets/images/check.png'
                                  : 'assets/images/video.png'))),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 270.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 124.w,
                    height: 54.w,
                    decoration: BoxDecoration(
                      color: isPhotography
                          ? AppColors.backgroundColor
                          : AppColors.backgroundColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: CustomText(
                          text: 'Photographer', color: AppColors.whiteColor),
                    )),
                  ),
                  Container(
                    width: 124.w,
                    height: 54.w,
                    decoration: BoxDecoration(
                      color: isVideography
                          ? AppColors.backgroundColor
                          : AppColors.backgroundColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: CustomText(
                          text: 'Videographer', color: AppColors.whiteColor),
                    )),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 300.w,
            ),
            CustomButton(
              title: 'Continue',
              onPressed: () async {
                if (isPhotography == false && isVideography == false) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: AppColors.backgroundColor,
                      content: CustomText(
                        text: 'Please select your service',
                        color: AppColors.whiteColor,
                        fontSized: 16.sp,
                      )));
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChooseServicesScreen(
                                service: isPhotography
                                    ? 'photography'
                                    : 'videography',
                              )));
                  Map data = {
                    'name': isPhotography ? 'Photographer3' : 'Videographer',
                    'categoryId': isPhotography ? "1" : "2",
                  };
                  // AuthHttpApiRepository().chooseServices(data).then((value) { });
                }
              },
              btnColor: AppColors.backgroundColor,
              btnTextColor: AppColors.whiteColor,
            )
          ],
        ),
      ),
    );
  }
}
