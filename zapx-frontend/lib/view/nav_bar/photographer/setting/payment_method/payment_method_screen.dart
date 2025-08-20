import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_app_bar.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_button.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/view/nav_bar/photographer/setting/transaction_history/transaction_history_screen.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  bool isInstant = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Payment'),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 100.h,
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      text: 'My Balance',
                      fontSized: 14.sp,
                      color: AppColors.whiteColor,
                    ),
                    SizedBox(height: 4.h),
                    CustomText(
                      text: '\$3,382.00',
                      fontSized: 24.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.whiteColor,
                    ),
                    SizedBox(height: 8.h),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const TransactionHistoryScreen()));
                      },
                      child: CustomText(
                        text: 'Transaction History',
                        fontSized: 14.sp,
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.h),
              CustomText(
                text: 'Deposit payment in your bank account',
                fontSized: 16.sp,
                color: AppColors.blackColor,
                fontWeight: FontWeight.w700,
              ),
              SizedBox(height: 6.h),
              CustomText(
                text: 'Deposit usually takes 1-3 business days.',
                fontSized: 12.sp,
                color: AppColors.greyColor.withOpacity(0.5),
              ),
              SizedBox(height: 20.h),
              CustomPoppinText(
                text: 'Enter Deposit Amount',
                fontSized: 14.sp,
                color: AppColors.blackColor,
                alignment: TextAlign.start,
                fontWeight: FontWeight.w600,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                style: TextStyle(
                    color: AppColors.blackColor,
                    fontSize: 14.sp,
                    fontFamily: 'nunito sans'),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.greyColor.withOpacity(0.1),
                  hintStyle: TextStyle(
                    color: AppColors.greyColor,
                    fontSize: 14.sp,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              CustomPoppinText(
                text: 'Deposit Type',
                fontSized: 14.sp,
                color: AppColors.blackColor,
                fontWeight: FontWeight.w600,
                alignment: TextAlign.start,
              ),
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isInstant = true;
                      });
                    },
                    child: Container(
                      width: 156.w,
                      height: 43.w,
                      decoration: BoxDecoration(
                        color: isInstant
                            ? AppColors.backgroundColor
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Center(
                        child: CustomText(
                          text: 'Instant',
                          fontSized: 16.sp,
                          color: isInstant
                              ? AppColors.whiteColor
                              : AppColors.greyColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isInstant = false;
                      });
                    },
                    child: Container(
                      width: 156.w,
                      height: 43.w,
                      decoration: BoxDecoration(
                        color: !isInstant
                            ? AppColors.backgroundColor
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Center(
                        child: CustomText(
                          text: 'Regular',
                          fontSized: 16.sp,
                          color: !isInstant
                              ? AppColors.whiteColor
                              : AppColors.greyColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 175.w),
              CustomButton(
                  title: 'Continue',
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const TransactionHistoryScreen()));
                  },
                  btnColor: AppColors.backgroundColor,
                  btnTextColor: AppColors.whiteColor)
            ],
          ),
        ),
      ),
    );
  }
}
