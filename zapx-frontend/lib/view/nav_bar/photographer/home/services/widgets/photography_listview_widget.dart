import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/view/nav_bar/user/profile/other_user/other_user_profile_screen.dart';

class PhotographyListview extends StatelessWidget {
  final String name;
  final String image;
  final String rating;
  final String reviews;
  const PhotographyListview({
    super.key,
    required this.name,
    required this.image,
    required this.rating,
    required this.reviews,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      scrollDirection: Axis.vertical,
      physics: const ScrollPhysics(parent: NeverScrollableScrollPhysics()),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => const OtherUserProfileScreen()));
          },
          child: Container(
            width: 327.w,
            height: 135.w,
            margin: EdgeInsets.only(bottom: 10.w),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              border: Border.all(color: AppColors.greyColor.withOpacity(0.1)),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(14.w),
                  child: Container(
                    width: 84.w,
                    height: 107.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: Image(
                        width: 84.w,
                        height: 107.w,
                        fit: BoxFit.cover,
                        image: AssetImage(image),
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 14.w),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          text: name,
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
                    SizedBox(height: 14.w),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          height: 12.w,
                          width: 12.w,
                          image: const AssetImage('assets/images/star.png'),
                        ),
                        SizedBox(width: 5.h),
                        CustomText(
                          text: rating,
                          fontSized: 12.0,
                          fontWeight: FontWeight.w700,
                          color: AppColors.blackColor,
                        ),
                        SizedBox(width: 2.h),
                        CustomText(
                          text: '($reviews)',
                          fontSized: 12.0,
                          fontWeight: FontWeight.w700,
                          color: AppColors.greyColor.withOpacity(0.5),
                        ),
                      ],
                    ),
                    SizedBox(height: 14.w),
                    Row(
                      children: [
                        const CustomText(
                          text: '\$20',
                          fontSized: 15.0,
                          fontWeight: FontWeight.w700,
                          color: AppColors.blackColor,
                        ),
                        CustomText(
                          text: '/hr',
                          fontSized: 15.0,
                          color: AppColors.greyColor.withOpacity(0.5),
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.only(right: 23.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image(
                        height: 31.w,
                        width: 31.w,
                        color: AppColors.backgroundColor,
                        image: const AssetImage(
                          'assets/images/invite_friend.png',
                        ),
                      ),
                      Image(
                        height: 31.w,
                        width: 31.w,
                        image: const AssetImage('assets/images/heart.png'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
