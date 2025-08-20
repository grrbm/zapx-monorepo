import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_app_bar.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_button.dart';

import '../../../user/profile/current_user/saved_photographer/booking/widgets/summary_row_item_widget.dart';

class CancelBookingScreen extends StatefulWidget {
  const CancelBookingScreen({super.key});

  @override
  State<CancelBookingScreen> createState() => _CancelBookingScreenState();
}

class _CancelBookingScreenState extends State<CancelBookingScreen> {
  final String description =
      'Here is the description of the booking lorem ipsum';
  final String addNotes = 'be on time';
  final List<String> images = [
    'assets/images/gallery1.png',
    'assets/images/gallery2.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: const CustomAppBar(title: 'Cancel Booking'),
      body: Center(
        child: Column(
          children: [
            Divider(
              color: AppColors.greyColor.withOpacity(0.2),
            ),
            SizedBox(
              height: 26.w,
            ),
            Container(
              width: 327.w,
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                border: Border.all(
                    width: 1.w, color: AppColors.greyColor.withOpacity(0.1)),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Padding(
                padding: EdgeInsets.all(20.0.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SummaryRowItem(
                      description: '1 hr 3 minutes',
                      title: 'Duration',
                      fontWeight: FontWeight.w400,
                    ),
                    SizedBox(
                      height: 16.w,
                    ),
                    const SummaryRowItem(
                      description: '05:300-06:00PM',
                      title: 'Timeslot',
                      fontWeight: FontWeight.w400,
                    ),
                    SizedBox(
                      height: 16.w,
                    ),
                    SummaryRowItem(
                      description: addNotes,
                      title: 'Notes',
                      fontWeight: FontWeight.w400,
                    ),
                    SizedBox(
                      height: 16.w,
                    ),
                    SummaryRowItem(
                      description: description,
                      title: 'Description',
                      fontWeight: FontWeight.w400,
                    ),
                    SizedBox(
                      height: 16.w,
                    ),
                    SummaryRowItem(
                      description: '\$60.00',
                      title: 'Amount Paid',
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 16.w,
            ),
            Container(
              width: 327.w,
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                border: Border.all(
                    width: 1.w, color: AppColors.greyColor.withOpacity(0.1)),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Padding(
                padding: EdgeInsets.all(20.0.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SummaryRowItem(
                      description: '\$60.00',
                      title: 'Refund Amount',
                      fontWeight: FontWeight.w400,
                    ),
                    SizedBox(
                      height: 16.w,
                    ),
                    SummaryRowItem(
                      description: 'Credit Card (**1234)',
                      title: 'Refund Method',
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 200.w,
            ),
            CustomButton(
              title: 'Cancel Booking & Refund',
              onPressed: () {},
              btnColor: AppColors.redColor,
              btnTextColor: AppColors.whiteColor,
              btnBorderColor: AppColors.redColor,
            )
          ],
        ),
      ),
    );
  }
}
