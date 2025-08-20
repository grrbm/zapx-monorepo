import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';

class ProfileSection extends StatelessWidget {
  const ProfileSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Image(
                  width: 24.h,
                  height: 24.h,
                  image: const AssetImage('assets/images/arrow_left.png')),
            ),
            Row(
              children: [
                Container(
                  width: 80.h,
                  height: 80.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(80),
                  ),
                  child: const Image(
                    image: AssetImage('assets/images/profile_picture.png'),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 9.w),
                      child: Row(
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
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 9.w),
                      child: CustomText(
                        text: '@erico_mov99',
                        fontSized: 12.sp,
                        fontWeight: FontWeight.normal,
                        color: AppColors.greyColor.withOpacity(0.5),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Padding(
                      padding: EdgeInsets.only(left: 9.w),
                      child: Row(
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
                    ),
                    SizedBox(
                      width: 230.w,
                      child: CustomText(
                        text: '3517 W. Gray St. Utica, Pennsylvania 57867',
                        fontSized: 12.sp,
                        color: AppColors.blackColor,
                        alignment: TextAlign.left,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
        Positioned(
          top: 50.w,
          right: 16.w,
          child: GestureDetector(
            onTap: () {
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => BookingScheduleScreen()));
            },
            child: Image(
              width: 28.w,
              height: 28.w,
              color: AppColors.backgroundColor,
              image: const AssetImage('assets/images/invite_friend.png'),
            ),
          ),
        ),
      ],
    );
  }
}
