import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/view/nav_bar/user/profile/current_user/saved_photographer/reviews/widgets/review_item_widget.dart';

class ReviewsTab extends StatelessWidget {
  final double paddingLeft;
  ReviewsTab({super.key, required this.paddingLeft});

  List<String> rating = [
    'All Stars',
    '5 Stars',
    '4 Stars',
    '3 Stars',
    '2 Stars',
    '1 Star'
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10.h),
        Padding(
          padding: EdgeInsets.only(left: 20.w),
          child: SizedBox(
            height: 50.h,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: rating.length,
                physics:
                    const ScrollPhysics(parent: NeverScrollableScrollPhysics()),
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: index == 0
                                  ? AppColors.backgroundColor
                                  : AppColors.greyColor1,
                              width: 1),
                          borderRadius: BorderRadius.circular(20),
                          color: index == 0
                              ? AppColors.backgroundColor
                              : AppColors.whiteColor),
                      height: 35.h,
                      width: 120.w,
                      child: Center(
                        child: CustomText(
                          text: rating[index],
                          fontSized: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: index == 0
                              ? AppColors.whiteColor
                              : AppColors.blackColor,
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ),
        SizedBox(height: 5.h),
        Expanded(
          child: ListView.builder(
              itemCount: 2,
              physics:
                  const ScrollPhysics(parent: NeverScrollableScrollPhysics()),
              itemBuilder: (context, index) {
                return ReviewItemWidget(
                  profilePicture: 'assets/images/profile_picture.png',
                  userName: 'Rocks Velkenjien',
                  reviewDescription:
                      'Cinemas is the ultimate experience to see new movies in Gold Class or Vmax. Find a cinema near you.',
                  rating: 3.0,
                  date: '10 Feb',
                  paddingLeft: paddingLeft,
                );
              }),
        ),
      ],
    );
  }
}
