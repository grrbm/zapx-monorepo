import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/view/nav_bar/photographer/booking/deliver_photos/deliver_photos.dart';

class OutStandingTabScreen extends StatelessWidget {
  OutStandingTabScreen({super.key, required this.context});
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 2,
        itemBuilder: (context, index) {
          return buildOrderCard();
        },
      ),
    );
  }

  Widget buildOrderCard() {
    return Padding(
      padding: EdgeInsets.only(
        left: 24.w,
        right: 24.w,
        top: 20.w,
        bottom: 10.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomText(
            text: "Customer Name",
            fontSized: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.blackColor,
            alignment: TextAlign.left,
          ),
          SizedBox(height: 20.w),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildTimeColumn('2', 'Days'),
              buildTimeColumn('23', 'Hours'),
              buildTimeColumn('23', 'Minutes'),
            ],
          ),
          SizedBox(height: 20.w),
          Container(
            decoration: BoxDecoration(
              color: AppColors.backgroundColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DeliverPhotos(),
                  ),
                );
              },
              child: CustomText(
                text: "Begin Delivery",
                fontSized: 16.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                alignment: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTimeColumn(String time, String unit) {
    return Column(
      children: [
        CustomText(
          text: time,
          fontSized: 14.0,
          fontWeight: FontWeight.w600,
          color: AppColors.blackColor,
          alignment: TextAlign.center,
        ),
        CustomText(
          text: unit,
          fontSized: 12.0,
          fontWeight: FontWeight.w400,
          color: AppColors.greyColor.withOpacity(0.5),
          alignment: TextAlign.center,
        ),
      ],
    );
  }
}
