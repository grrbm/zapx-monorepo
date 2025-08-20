import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:zapxx/configs/color/color.dart';

class ConfirmBookingInputTextField extends StatelessWidget {
  final double height;
  final int maxLines;
  final TextEditingController controller;
  const ConfirmBookingInputTextField({
    super.key,
    required this.height,
    required this.maxLines,
    required this.controller,
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
            color: AppColors.blackColor, fontFamily: 'nunito sans'),
        decoration: InputDecoration(
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
