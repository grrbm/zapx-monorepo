import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';

class BottomListviewStack extends StatelessWidget {
  const BottomListviewStack({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20.w,
      left: 0,
      right: 0,
      child: SizedBox(
        height: 130.w,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 13.w),
                child: Stack(
                  children: [
                    Container(
                      width: 300.w,
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
                                'assets/images/gallery1.png',
                                width: 88.w,
                                height: 96.w,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const CustomText(
                                    text: 'Westfield Coffee shop',
                                    fontSized: 14.0,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.blackColor,
                                  ),
                                  SizedBox(height: 3.w),
                                  const CustomText(
                                    text: 'Address: 12 Street Ontario,',
                                    fontSized: 12.0,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.greyColor,
                                  ),
                                  const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomText(
                                        text: 'Canada',
                                        fontSized: 12.0,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.greyColor,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 3.w),
                                  const CustomText(
                                    text: '12:00PM-01:00AM',
                                    fontSized: 12.0,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.backgroundColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 20.w,
                      child: Padding(
                        padding: EdgeInsets.only(right: 25.0.w),
                        child: Container(
                          width: 64.w,
                          height: 32.w,
                          decoration: BoxDecoration(
                            color: AppColors.backgroundColor.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: const Center(
                            child: CustomText(
                              text: 'View',
                              fontSized: 12.0,
                              fontWeight: FontWeight.w500,
                              color: AppColors.backgroundColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 20,
                      top: 15.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 5.25.w, horizontal: 6.5.w),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundColor,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: const Center(
                          child: CustomText(
                            text: 'Monday',
                            fontSized: 9.0,
                            fontWeight: FontWeight.w500,
                            color: AppColors.whiteColor,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }
}
