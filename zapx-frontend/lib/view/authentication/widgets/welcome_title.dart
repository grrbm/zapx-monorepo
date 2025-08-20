import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';

class WelcomeTitle extends StatelessWidget {
  final String title;
  final double topPadding;
  final String subTitle;
  final TextAlign textAlign;
  final CrossAxisAlignment crossAxisAlignment;

  const WelcomeTitle({
    super.key,
    required this.title,
    required this.subTitle,
    required this.crossAxisAlignment,
    required this.textAlign,
    required this.topPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          CustomText(
            text: title,
            fontSized: 24.sp,
            alignment: textAlign,
            color: AppColors.blackColor,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(
            height: 8.h,
          ),
          CustomText(
            text: subTitle,
            alignment: textAlign,
            color: AppColors.greyColor,
            fontSized: 16.sp,
            fontWeight: FontWeight.normal,
          ),
        ],
      ),
    );
  }
}
