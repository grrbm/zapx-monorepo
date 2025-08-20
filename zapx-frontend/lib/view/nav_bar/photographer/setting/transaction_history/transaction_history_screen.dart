import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_app_bar.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Transaction History',
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Image(
                width: 24.w,
                height: 24.w,
                color: AppColors.greyColor.withOpacity(0.5),
                image: const AssetImage('assets/images/search_normal.png')),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          children: [
            const FilterRow(),
            Padding(
              padding: EdgeInsets.only(top: 24.w, bottom: 13.w),
              child: const NotificationRow(),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Stack(
                        children: [
                          Container(
                            width: 327.w,
                            height: 76.w,
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image(
                                    width: 36.w,
                                    height: 36.w,
                                    fit: BoxFit.cover,
                                    image: const AssetImage(
                                        'assets/images/dollor_image.png')),
                                Container(
                                  width: 242.w,
                                  height: 52.w,
                                  child: RichText(
                                    text: TextSpan(
                                        text: '\$100 Deposit',
                                        style: TextStyle(
                                            color: AppColors.blackColor,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Poppins'),
                                        children: [
                                          TextSpan(
                                            text:
                                                '  was initiated  on instant deposit type',
                                            style: TextStyle(
                                                color: AppColors.greyColor
                                                    .withOpacity(0.6),
                                                fontSize: 14.sp,
                                                fontFamily: 'Poppins'),
                                          ),
                                        ]),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                              bottom: 13.w,
                              right: 8.w,
                              child: CustomText(
                                text: '8:00 AM',
                                fontSized: 8.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.backgroundColor,
                              ))
                        ],
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationRow extends StatelessWidget {
  const NotificationRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CustomText(
              text: 'Today',
              fontSized: 16.sp,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(
              width: 10.w,
            ),
            Container(
              width: 16.w,
              height: 16.w,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.backgroundColor, width: 1),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Center(
                child: CustomText(
                  text: '3',
                  fontSized: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.backgroundColor,
                ),
              ),
            )
          ],
        ),
        CustomText(
          text: 'Mark All As Read',
          fontSized: 12.w,
          fontWeight: FontWeight.w500,
          color: AppColors.backgroundColor,
        )
      ],
    );
  }
}

class FilterRow extends StatelessWidget {
  const FilterRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 85.w,
          height: 40.w,
          decoration: BoxDecoration(
              color: AppColors.greyColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12.r)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text: 'All',
                fontSized: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.blackColor,
              ),
              SizedBox(
                width: 6.w,
              ),
              Image(
                  width: 16.w,
                  height: 16.w,
                  color: AppColors.greyColor.withOpacity(0.5),
                  image: const AssetImage('assets/images/arrow_down.png')),
            ],
          ),
        ),
        Container(
          width: 85.w,
          height: 40.w,
          decoration: BoxDecoration(
              color: AppColors.greyColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12.r)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                  width: 16.w,
                  height: 16.w,
                  color: AppColors.greyColor.withOpacity(0.5),
                  image: const AssetImage('assets/images/filter.png')),
              SizedBox(
                width: 6.w,
              ),
              CustomText(
                text: 'Filter',
                fontSized: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.blackColor,
              ),
            ],
          ),
        )
      ],
    );
  }
}
