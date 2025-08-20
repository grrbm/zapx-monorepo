import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';

class SelectServiceButton extends StatelessWidget {
  const SelectServiceButton(
      {super.key,
      required this.selectedIndex,
      this.onTap,
      this.title,
      this.buttonValue});

  final int selectedIndex;
  final VoidCallback? onTap;
  final String? title;
  final int? buttonValue;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160.w,
        height: 38.w,
        decoration: BoxDecoration(
          color: buttonValue == selectedIndex
              ? AppColors.backgroundColor
              : AppColors.whiteColor,
          borderRadius: BorderRadius.circular(9.r),
        ),
        child: Center(
          child: CustomText(
            text: title ?? "",
            fontSized: 12.sp,
            fontWeight: FontWeight.w600,
            color: buttonValue == selectedIndex
                ? AppColors.whiteColor
                : AppColors.blackColor,
          ),
        ),
      ),
    );
  }
}
