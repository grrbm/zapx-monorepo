import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:zapxx/configs/color/color.dart';

import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/view/nav_bar/user/message/chat/booking/confirm_booking/confirm_booking_summary_Screen.dart';

class BookingRequestWidget extends StatelessWidget {
  const BookingRequestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 336.w,
      height: 277.w,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(25.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(
              text: 'Westfield Coffee Shop',
              fontSized: 14.0,
              fontWeight: FontWeight.w700,
              color: AppColors.blackColor,
            ),
            CustomText(
              text: 'Address: 12 Street Ontario, Canada',
              fontSized: 12.0,
              color: AppColors.greyColor.withOpacity(0.4),
            ),
            SizedBox(
              height: 17.w,
            ),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 0.75,
                        color: AppColors.greyColor.withOpacity(0.2)),
                    borderRadius: BorderRadius.circular(40.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10.w),
                    child: Image(
                        width: 19.w,
                        height: 19.w,
                        fit: BoxFit.contain,
                        image: const AssetImage('assets/images/Calendar.png')),
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(
                      text: '8:00-9:00 AM, October 16, 2023',
                      fontSized: 14.0,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                    ),
                    CustomText(
                      text: 'Schedule',
                      fontSized: 12.0,
                      color: AppColors.greyColor.withOpacity(0.4),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 17.w,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 209.w,
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5.r),
                          child: Image(
                              width: 40.w,
                              height: 40.w,
                              fit: BoxFit.contain,
                              image: const AssetImage(
                                  'assets/images/gallery1.png')),
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomText(
                            text: 'John Williams ',
                            fontSized: 14.0,
                            fontWeight: FontWeight.w600,
                            color: AppColors.blackColor,
                          ),
                          CustomText(
                            text: 'Pet Photography',
                            fontSized: 12.0,
                            fontWeight: FontWeight.w500,
                            color: AppColors.greyColor.withOpacity(0.4),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 64.w,
                  height: 32.w,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: const Center(
                    child: CustomText(
                      text: '\$25.98',
                      fontSized: 12.0,
                      fontWeight: FontWeight.w500,
                      color: AppColors.backgroundColor,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 25.w,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 135.w,
                    height: 48.w,
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: AppColors.blackColor, width: 1),
                    ),
                    child: const Center(
                      child: CustomText(
                        text: 'Decline',
                        fontSized: 12.0,
                        fontWeight: FontWeight.w700,
                        color: AppColors.blackColor,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const ConfirmBookingSummaryScreen()));
                  },
                  child: Container(
                    width: 135.w,
                    height: 48.w,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: const Center(
                      child: CustomText(
                        text: 'Review',
                        fontSized: 12.0,
                        fontWeight: FontWeight.w700,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
