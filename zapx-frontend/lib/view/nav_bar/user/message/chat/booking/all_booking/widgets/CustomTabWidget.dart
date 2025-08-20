import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';

class CustomTabWidget extends StatelessWidget {
  const CustomTabWidget({
    super.key,
    required this.selectedIndex,
    required this.index,
    required this.title,
  });

  final int selectedIndex;
  final int index;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 108.w,
      height: 38.w,
      decoration: BoxDecoration(
        color: selectedIndex == index
            ? AppColors.backgroundColor
            : AppColors.whiteColor,
        borderRadius: BorderRadius.circular(9.r),
      ),
      child: Center(
        child: CustomText(
          text: title,
          fontSized: 15.0,
          fontWeight: FontWeight.w700,
          color: selectedIndex == index
              ? AppColors.whiteColor
              : AppColors.blackColor,
        ),
      ),
    );
  }
}
