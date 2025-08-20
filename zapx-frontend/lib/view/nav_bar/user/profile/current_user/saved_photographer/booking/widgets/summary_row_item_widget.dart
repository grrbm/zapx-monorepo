import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; 
import 'package:zapxx/configs/color/color.dart'; 
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';

class SummaryRowItem extends StatelessWidget {
  const SummaryRowItem({
    super.key,
    required this.title,
    required this.description,
    required this.fontWeight,
  });

  final String title;
  final String description;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 130.w,
          child: CustomText(
            text: title,
            fontSized: 14.0,
            color: AppColors.blackColor,
            alignment: TextAlign.left,
            fontWeight: fontWeight,
          ),
        ),
        SizedBox(
          width: 147.w,
          child: CustomText(
            text: description,
            fontSized: 14.0,
            color: AppColors.blackColor,
            fontWeight: FontWeight.w500,
            alignment: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
