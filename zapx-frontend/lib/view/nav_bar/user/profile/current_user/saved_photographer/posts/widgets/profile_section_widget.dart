import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapxx/configs/color/color.dart'; 
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';

class ProfileSection extends StatelessWidget {
  const ProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Container(
            width: 80.h,
            height: 80.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(80),
            ),
            child: const Image(
              image: AssetImage('assets/images/profile_picture.png'),
            ),
          ),
        ),
        SizedBox(height: 7.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              text: 'Erico Movement',
              fontSized: 14.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.blackColor,
            ),
            SizedBox(width: 4.w),
            Image(
              width: 19.h,
              height: 19.h,
              image: const AssetImage('assets/images/verify.png'),
            ),
          ],
        ),
        CustomText(
          text: '@erico_mov99',
          fontSized: 12.sp,
          fontWeight: FontWeight.normal,
          color: AppColors.greyColor.withOpacity(0.5),
        ),
        SizedBox(height: 4.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              height: 12.w,
              width: 12.w,
              image: const AssetImage('assets/images/star.png'),
            ),
            SizedBox(width: 5.h),
            const CustomText(
              text: '4.8',
              fontSized: 12.0,
              fontWeight: FontWeight.w700,
              color: AppColors.blackColor,
            ),
            SizedBox(width: 2.h),
            CustomText(
              text: '(87)',
              fontSized: 12.0,
              fontWeight: FontWeight.w700,
              color: AppColors.greyColor.withOpacity(0.5),
            ),
          ],
        ),
        CustomText(
          text: '3517 W. Gray St. Utica, Pennsylvania 57867',
          fontSized: 12.sp,
          color: AppColors.blackColor,
        ),
      ],
    );
  }
}
