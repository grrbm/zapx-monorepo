import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; 
import 'package:zapxx/configs/color/color.dart'; 
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';

class GigCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String location;
  final double price;

  const GigCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.location,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 13.w),
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                  color: AppColors.greyColor.withOpacity(0.04),
                  spreadRadius: 22,
                  blurRadius: 5,
                  offset: const Offset(0, 1))
            ]),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  imageUrl,
                  width: 90.w,
                  height: 90.w,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: title,
                      fontSized: 14.0,
                      fontWeight: FontWeight.w700,
                      color: AppColors.blackColor,
                    ),
                    SizedBox(height: 5.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Image(
                                  width: 12.w,
                                  height: 12.w,
                                  image: const AssetImage(
                                      'assets/images/location.png')),
                            ),
                            CustomText(
                              text: location,
                              fontSized: 12.0,
                              fontWeight: FontWeight.w500,
                              color: AppColors.greyColor,
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 25.0.w),
                          child: Container(
                            width: 64.w,
                            height: 32.w,
                            decoration: BoxDecoration(
                              color:
                                  AppColors.backgroundColor.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Center(
                              child: CustomText(
                                text: '\$$price',
                                fontSized: 12.0,
                                fontWeight: FontWeight.w500,
                                color: AppColors.backgroundColor,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
