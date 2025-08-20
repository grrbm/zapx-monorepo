import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';

class CustomButton extends StatelessWidget {
  final Color color;
  final String text;
  final Color textColor;
  final VoidCallback onTap;

  const CustomButton({
    Key? key,
    required this.color,
    required this.text,
    required this.textColor,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 93.w,
        height: 38.w,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: CustomText(
            text: text,
            fontSized: 13.0,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
