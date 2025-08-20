import 'package:flutter/material.dart';
import 'package:zapxx/configs/color/color.dart';

class CustomButton extends StatelessWidget {
  final onPressed;
  final text;
  final fontSize;
  final isloading;
  final height;
  final width;
  const CustomButton(
      {super.key,
      this.onPressed,
      this.text,
      this.fontSize,
      this.isloading = false,
      this.height,
      this.width});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            color: AppColors.backgroundColor,
            borderRadius: BorderRadius.circular(28)),
        child: Center(
          child: isloading
              ? const CircularProgressIndicator(
                  color: Colors.white,
                )
              : Text(
                  text ?? "",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: fontSize,
                      fontWeight: FontWeight.w500),
                ),
        ),
      ),
    );
  }
}
