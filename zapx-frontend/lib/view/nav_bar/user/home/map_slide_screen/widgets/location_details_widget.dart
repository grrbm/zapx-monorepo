import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';

class LocationDetails extends StatelessWidget {
  const LocationDetails({super.key, required this.location});
  final String location;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'Location Details',
            fontSized: 14.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.blackColor,
          ),
          SizedBox(height: 8.h),
          CustomText(
            text: location,
            fontSized: 13.sp,
            alignment: TextAlign.start,
            color: AppColors.blackColor,
          ),
        ],
      ),
    );
  }
}
