import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_app_bar.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';

class TermsOfServicesScreen extends StatefulWidget {
  const TermsOfServicesScreen({super.key});

  @override
  State<TermsOfServicesScreen> createState() => _TermsOfServicesScreenState();
}

class _TermsOfServicesScreenState extends State<TermsOfServicesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: const CustomAppBar(title: 'Terms of services'),
        body: Center(
          child: Column(
            children: [
              Divider(
                color: AppColors.greyColor.withOpacity(0.1),
              ),
              Padding(
                padding: EdgeInsets.all(25.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: 'Overview',
                      fontSized: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                      alignment: TextAlign.start,
                    ),
                    SizedBox(
                      height: 10.w,
                    ),
                    CustomText(
                      text:
                          'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor.',
                      fontSized: 14.sp,
                      fontWeight: FontWeight.w300,
                      color: AppColors.greyColor.withOpacity(0.5),
                      alignment: TextAlign.start,
                    ),
                    SizedBox(
                      height: 10.w,
                    ),
                    CustomText(
                      text: 'Mission',
                      fontSized: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                      alignment: TextAlign.start,
                    ),
                    SizedBox(
                      height: 10.w,
                    ),
                    CustomText(
                      text:
                          'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical.',
                      fontSized: 14.sp,
                      fontWeight: FontWeight.w300,
                      color: AppColors.greyColor.withOpacity(0.5),
                      alignment: TextAlign.start,
                    ),
                    SizedBox(
                      height: 10.w,
                    ),
                    CustomText(
                      text: 'Background',
                      fontSized: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                      alignment: TextAlign.start,
                    ),
                    SizedBox(
                      height: 10.w,
                    ),
                    CustomText(
                      text:
                          'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites.',
                      fontSized: 14.sp,
                      fontWeight: FontWeight.w300,
                      color: AppColors.greyColor.withOpacity(0.5),
                      alignment: TextAlign.start,
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
