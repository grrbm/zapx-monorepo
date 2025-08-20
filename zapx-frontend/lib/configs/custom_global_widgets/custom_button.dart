import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final Color btnColor;
  final Color btnTextColor;
  Color? btnBorderColor;
  final double? borderRadius;
  final double? height, width;
  final bool loading;

  CustomButton(
      {super.key,
      required this.title,
      required this.onPressed,
      required this.btnColor,
      required this.btnTextColor,
      this.btnBorderColor,
      this.borderRadius = 50,
      this.height,
      this.width,
      this.loading = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: height ?? 56.w,
        width: width ?? 327.w,
        decoration: BoxDecoration(
          color: btnColor,
          borderRadius: BorderRadius.circular(borderRadius ?? 50),
          border: Border.all(
            color: btnBorderColor ?? AppColors.backgroundColor,
            width: 1,
          ),
        ),
        child: Center(
            child: loading
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : CustomText(
                    text: title,
                    color: btnTextColor,
                    fontSized: 16.sp,
                    fontWeight: FontWeight.w600,
                  )),
      ),
    );
  }
}
