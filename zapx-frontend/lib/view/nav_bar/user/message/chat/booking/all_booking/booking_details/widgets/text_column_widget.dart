import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:zapxx/configs/color/color.dart'; 
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';


class TextColumnWidget extends StatelessWidget {
  final String title;
  final String description;
  const TextColumnWidget({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 343.w,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 11,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: title,
              fontSized: 14.0,
              fontWeight: FontWeight.w500,
              color: AppColors.greyColor.withOpacity(0.8),
            ),
            SizedBox(
              height: 4.w,
            ),
            CustomText(
              text: description,
              fontSized: 14.0,
              alignment: TextAlign.start,
            )
          ],
        ),
      ),
    );
  }
}
