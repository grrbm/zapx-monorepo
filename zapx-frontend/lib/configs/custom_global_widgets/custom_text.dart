import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_screenutil/flutter_screenutil.dart';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';
import 'package:zapxx/configs/color/color.dart';

class CustomText extends StatelessWidget {
  final alignment;
  final String text;
  final color;
  final fontSized;
  final fontStyle;
  final fontWeight;
  final textOverflow;
  final int maxLines;
  const CustomText({
    super.key,
    this.alignment,
    required this.text,
    this.color,
    this.fontSized,
    this.textOverflow,
    this.fontWeight,
    this.fontStyle,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text.tr,
      textAlign: alignment ?? TextAlign.center,
      overflow: textOverflow ?? TextOverflow.ellipsis,
      maxLines: maxLines,
      style: TextStyle(
        color: color ?? AppColors.blackColor,
        fontSize: fontSized ?? 18.sp,
        fontStyle: fontStyle ?? FontStyle.normal,
        fontWeight: fontWeight ?? FontWeight.w400,
        fontFamily: 'nunito sans',
      ),
    );
  }
}

class CustomPoppinText extends StatelessWidget {
  final alignment;
  final String text;
  final color;
  final fontSized;
  final fontWeight;
  const CustomPoppinText({
    super.key,
    this.alignment,
    required this.text,
    this.color,
    this.fontSized,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text.tr,
      textAlign: alignment ?? TextAlign.center,
      style: TextStyle(
        color: color ?? AppColors.blackColor,
        fontSize: fontSized ?? 18.sp,
        fontWeight: fontWeight ?? FontWeight.w400,
        fontFamily: 'Poppins',
      ),
    );
  }
}
