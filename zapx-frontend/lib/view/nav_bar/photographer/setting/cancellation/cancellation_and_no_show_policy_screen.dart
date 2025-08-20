import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_app_bar.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';

class CancellationAndNoShowPolicyScreen extends StatefulWidget {
  const CancellationAndNoShowPolicyScreen({super.key});

  @override
  State<CancellationAndNoShowPolicyScreen> createState() =>
      _CancellationAndNoShowPolicyScreenState();
}

class _CancellationAndNoShowPolicyScreenState
    extends State<CancellationAndNoShowPolicyScreen> {
  bool isFeeEnabled = false;
  int selectedCancellationFee = 1; // 1: 50%, 2: Default, 3: Custom
  int selectedNoShowFee = 1; // 1: 100%, 2: Default, 3: Custom

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Cancellation & No Show Policy'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20.w,
            ),
            Row(
              children: [
                Checkbox(
                  value: isFeeEnabled,
                  activeColor: AppColors.backgroundColor,
                  onChanged: (value) {
                    setState(() {
                      isFeeEnabled = value!;
                    });
                  },
                ),
                CustomText(
                  text: 'Set Cancellation/No Show Fee',
                  fontSized: 14.sp,
                  color: AppColors.blackColor,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
            SizedBox(height: 10.w),

            // Cancellation Fee
            CustomText(
              text: 'Cancellation Fee',
              fontSized: 14.sp,
              color: AppColors.blackColor,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: 10.w),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSelectableButton('50%', 1, selectedCancellationFee, () {
                  setState(() {
                    selectedCancellationFee = 1;
                  });
                }),
                _buildSelectableButton('Default', 2, selectedCancellationFee,
                    () {
                  setState(() {
                    selectedCancellationFee = 2;
                  });
                }),
                _buildSelectableButton('Custom', 3, selectedCancellationFee,
                    () {
                  setState(() {
                    selectedCancellationFee = 3;
                  });
                }),
              ],
            ),
            SizedBox(height: 13.w),

            // No Show Fee
            CustomText(
              text: 'No Show Fee',
              fontSized: 14.sp,
              color: AppColors.blackColor,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: 10.w),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSelectableButton('100%', 1, selectedNoShowFee, () {
                  setState(() {
                    selectedNoShowFee = 1;
                  });
                }),
                _buildSelectableButton('Default', 2, selectedNoShowFee, () {
                  setState(() {
                    selectedNoShowFee = 2;
                  });
                }),
                _buildSelectableButton('Custom', 3, selectedNoShowFee, () {
                  setState(() {
                    selectedNoShowFee = 3;
                  });
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build selectable buttons
  Widget _buildSelectableButton(
      String text, int index, int selectedIndex, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 106.w,
        height: 52.w,
        decoration: BoxDecoration(
          color: selectedIndex == index
              ? AppColors.backgroundColor
              : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Center(
          child: CustomText(
            text: text,
            fontSized: 14.sp,
            color: selectedIndex == index
                ? AppColors.whiteColor
                : AppColors.greyColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
