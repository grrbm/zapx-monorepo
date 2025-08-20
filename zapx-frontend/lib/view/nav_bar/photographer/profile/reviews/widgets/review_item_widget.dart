import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';

class ReviewItemWidget extends StatelessWidget {
  final String profilePicture;
  final String userName;
  final String reviewDescription;
  final double rating;
  final String date;
  final double paddingLeft;
  const ReviewItemWidget(
      {super.key,
      required this.profilePicture,
      required this.userName,
      required this.reviewDescription,
      required this.rating,
      required this.date,
      required this.paddingLeft});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: paddingLeft, top: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image(
            width: 34.h,
            height: 34.h,
            image: AssetImage(profilePicture),
          ),
          SizedBox(
            width: 16.w,
          ),
          SizedBox(
            width: 250.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: userName,
                      fontSized: 15.0,
                      fontWeight: FontWeight.w500,
                      color: AppColors.blackColor,
                    ),
                    CustomText(
                      text: date,
                      fontSized: 15.0,
                      fontWeight: FontWeight.w500,
                      color: AppColors.greyColor.withOpacity(0.5),
                    )
                  ],
                ),
                SizedBox(
                  height: 4.h,
                ),
                RatingBar.builder(
                  initialRating: rating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 15,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) =>
                      const Image(image: AssetImage('assets/images/star.png')),
                  onRatingUpdate: (rating) {
                    print(rating);
                  },
                ),
                SizedBox(
                  height: 9.h,
                ),
                CustomText(
                  text: reviewDescription,
                  fontSized: 14.0,
                  alignment: TextAlign.left,
                  color: AppColors.blackColor,
                ),
                SizedBox(
                  height: 15.h,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
