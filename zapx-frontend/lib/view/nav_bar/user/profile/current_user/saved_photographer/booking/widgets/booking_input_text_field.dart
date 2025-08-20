import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapxx/configs/color/color.dart';

class BookingInputTextField extends StatelessWidget {
  final double height;
  final int maxLines;
  final String hintText;
  final TextEditingController controller;
  const BookingInputTextField({
    super.key,
    required this.height,
    required this.maxLines,
    required this.controller,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(
          color: AppColors.blackColor,
          fontFamily: 'nunito sans',
        ),
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: EdgeInsets.symmetric(
            vertical: 16.h,
            horizontal: 12.w,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
