import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapxx/configs/color/color.dart'; 

import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/view/nav_bar/user/message/chat/booking/all_booking/booking_details/widgets/dialog_button_widget.dart';

class myDialog {
  cancelDialog(context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.whiteColor,
          title: const CustomText(
            text: 'Please Note!',
            fontSized: 19.5,
            fontWeight: FontWeight.w700,
            color: AppColors.backgroundColor,
          ),
          content: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: SizedBox(
              width: 240.w,
              child: const CustomText(
                text:
                    'Shakeel has a 50% cancelation fee, Do you wish to proceed?',
                fontSized: 13.0,
                color: AppColors.blackColor,
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                  color: AppColors.whiteColor,
                  text: 'Close',
                  textColor: AppColors.redColor,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(
                  width: 16.w,
                ),
                CustomButton(
                  color: AppColors.backgroundColor,
                  text: 'Cancel',
                  textColor: AppColors.whiteColor,
                  onTap: () {
                    Navigator.pop(context);
                    cancelConfirmationDialog(context);
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  cancelConfirmationDialog(context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.whiteColor,
          title: const CustomText(
            text: 'Are you sure to cancel?',
            fontSized: 19.5,
            fontWeight: FontWeight.w700,
            color: AppColors.backgroundColor,
          ),
          content: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: SizedBox(
              width: 240.w,
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                  color: AppColors.whiteColor,
                  text: 'No',
                  textColor: AppColors.redColor,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(
                  width: 16.w,
                ),
                CustomButton(
                  color: AppColors.backgroundColor,
                  text: 'Yes',
                  textColor: AppColors.whiteColor,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
