import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/view/nav_bar/photographer/booking/booking_cancel/booking_cancel_screen.dart';

class BookingCancelWidget extends StatefulWidget {
  final String status;
  const BookingCancelWidget({super.key, required this.status});

  @override
  State<BookingCancelWidget> createState() => _BookingCancelWidgetState();
}

class _BookingCancelWidgetState extends State<BookingCancelWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 343.w,
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(25.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage('assets/images/gallery1.png'),
                    ),
                    SizedBox(
                      width: 16.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomText(
                          text: 'Pet Photography',
                          fontSized: 14.0,
                          fontWeight: FontWeight.w700,
                          color: AppColors.blackColor,
                        ),
                        CustomText(
                          text: 'Reference Code: #D-571224',
                          fontSized: 12.0,
                          color: AppColors.greyColor.withOpacity(0.4),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 12.w,
                ),
                const Divider(
                  thickness: 0.3,
                  height: 0,
                ),
                SizedBox(
                  height: 12.w,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: 'Status',
                      fontSized: 14.0,
                      fontWeight: FontWeight.w500,
                      color: AppColors.greyColor.withOpacity(0.4),
                    ),
                    Container(
                      width: 76.w,
                      height: 24.w,
                      decoration: BoxDecoration(
                        color: widget.status == 'Cancelled'
                            ? AppColors.redColor.withOpacity(0.05)
                            : AppColors.backgroundColor.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Center(
                        child: CustomText(
                          text: widget.status,
                          fontSized: 14.0,
                          fontWeight: FontWeight.w600,
                          color: widget.status == 'Cancelled'
                              ? AppColors.redColor
                              : AppColors.backgroundColor,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10.w,
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
                            image:
                                const AssetImage('assets/images/Calendar.png')),
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
                      width: 200.w,
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
                                text: 'Service Provider',
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
                      width: 60.w,
                      height: 24.w,
                      child: const CustomText(
                        text: '\$2500',
                        fontSized: 16.0,
                        fontWeight: FontWeight.w700,
                        color: AppColors.backgroundColor,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
            top: 25.w,
            right: 25.w,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CancelBookingScreen()));
              },
              child: Image(
                  width: 26.w,
                  height: 26.w,
                  image: const AssetImage('assets/images/cancel.png')),
            ))
      ],
    );
  }
}
