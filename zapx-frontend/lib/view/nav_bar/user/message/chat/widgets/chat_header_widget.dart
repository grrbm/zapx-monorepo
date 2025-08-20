import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';

class ChatHeader extends StatelessWidget {
  const ChatHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180.w,
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        border: Border.all(
          color: AppColors.greyColor.withOpacity(0.2),
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CustomText(
            text: 'Pet Photography',
            fontSized: 14.0,
            color: AppColors.blackColor,
          ),
          Row(
            children: [
              Image(
                  width: 14.w,
                  height: 14.w,
                  image: const AssetImage('assets/images/Calendar.png')),
              SizedBox(
                width: 4.w,
              ),
              const CustomText(
                text: 'Sep 29, 2022',
                fontSized: 10.0,
                color: AppColors.blackColor,
              ),
              SizedBox(
                width: 14.w,
              ),
              Image(
                  width: 14.w,
                  height: 14.w,
                  image: const AssetImage('assets/images/clock.png')),
              SizedBox(
                width: 4.w,
              ),
              const CustomText(
                text: '09:00 PM',
                fontSized: 10.0,
                color: AppColors.blackColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
