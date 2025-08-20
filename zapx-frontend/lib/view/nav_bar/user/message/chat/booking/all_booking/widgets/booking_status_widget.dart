import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/configs/date_format.dart';
import 'package:zapxx/configs/app_url.dart';
import 'package:zapxx/configs/components/network_image_widget.dart';
import 'package:zapxx/view/nav_bar/user/message/chat/booking/all_booking/booking_details/booking_details_screen.dart';
import 'package:zapxx/view/nav_bar/user/message/chat/booking/all_booking/deliver/deliver_screen.dart';
import 'package:zapxx/view/nav_bar/user/booking/booking_model.dart';

class BookingStatusWidget extends StatelessWidget {
  final String status;
  final Booking? booking;
  const BookingStatusWidget({super.key, required this.status, this.booking});

  String get displayStatus {
    if (status == 'AWAITING_BOOKING_CONFIRMATION') return 'Pending';
    if (status == 'INPROGRESS') return 'Ongoing';
    if (status == 'COMPLETED') return 'Completed';
    if (status == 'DECLINED') return 'Cancelled';
    if (status == 'OFFER') return 'Offer';
    return status;
  }

  @override
  Widget build(BuildContext context) {
    if (booking == null) {
      return Container(
        width: 343.w,
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(25.w),
          child: Center(child: Text('No booking data available')),
        ),
      );
    }

    return Container(
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
                CircleAvatar(
                  radius: 25,
                  backgroundImage:
                      booking!.seller.user.profileImage.url.isNotEmpty
                          ? NetworkImage(
                            AppUrl.baseUrl +
                                "/" +
                                booking!.seller.user.profileImage.url,
                          )
                          : const AssetImage('assets/images/gallery1.png')
                              as ImageProvider,
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: CustomText(
                    text:
                        booking!.description.isNotEmpty
                            ? booking!.description
                            : 'No Description',
                    fontSized: 14.0,
                    fontWeight: FontWeight.w700,
                    color: AppColors.blackColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.w),
            const Divider(thickness: 0.3, height: 0),
            SizedBox(height: 12.w),
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
                  width: 90.w,
                  height: 24.w,
                  decoration: BoxDecoration(
                    color:
                        status == 'COMPLETED'
                            ? AppColors.redColor.withOpacity(0.05)
                            : AppColors.backgroundColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Center(
                    child: CustomText(
                      text: displayStatus,
                      fontSized: 12.0,
                      fontWeight: FontWeight.w600,
                      color:
                          status == 'COMPLETED'
                              ? AppColors.redColor
                              : AppColors.backgroundColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.w),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 0.75,
                      color: AppColors.greyColor.withOpacity(0.2),
                    ),
                    borderRadius: BorderRadius.circular(40.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10.w),
                    child: Image(
                      width: 19.w,
                      height: 19.w,
                      fit: BoxFit.contain,
                      image: const AssetImage('assets/images/Calendar.png'),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text:
                            '${formatTime(booking!.startTime.toString())} - ${formatTime(booking!.endTime.toString())}, ${formatDate(booking!.date.toString())}',
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
                  ),
                ),
              ],
            ),
            SizedBox(height: 17.w),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5.r),
                          child:
                              booking!.seller.user.profileImage.url.isNotEmpty
                                  ? NetworkImageWidget(
                                    imageUrl:
                                        AppUrl.baseUrl +
                                        "/" +
                                        booking!.seller.user.profileImage.url,
                                    width: 40.w,
                                    height: 40.w,
                                  )
                                  : Image(
                                    width: 40.w,
                                    height: 40.w,
                                    fit: BoxFit.contain,
                                    image: const AssetImage(
                                      'assets/images/gallery1.png',
                                    ),
                                  ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: booking!.seller.user.fullName,
                              fontSized: 14.0,
                              fontWeight: FontWeight.w600,
                              color: AppColors.blackColor,
                            ),
                            CustomText(
                              text:
                                  booking!.description.isNotEmpty
                                      ? booking!.description
                                      : 'Service Provider',
                              fontSized: 12.0,
                              fontWeight: FontWeight.w500,
                              color: AppColors.greyColor.withOpacity(0.4),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10.w),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                status == 'OutStanding'
                                    ? const DeliverScreen()
                                    : BookingDetailsScreen(booking: booking),
                      ),
                    );
                  },
                  child: Container(
                    width: 93.w,
                    height: 38.w,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundColor,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Center(
                      child: CustomText(
                        text:
                            status == 'OutStanding'
                                ? 'Deliver'
                                : 'View Details',
                        fontSized: 13.0,
                        fontWeight: FontWeight.w600,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
