import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapxx/configs/color/color.dart'; 
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';

class MessageButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final Color btnColor;
  final Color btnTextColor;
  const MessageButton({
    super.key,
    required this.title,
    required this.onPressed,
    required this.btnColor,
    required this.btnTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 35.w,
        width: 252.w,
        decoration: BoxDecoration(
          color: btnColor,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: AppColors.backgroundColor,
            width: 1,
          ),
        ),
        child: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              width: 13.h,
              height: 13.h,
              image: const AssetImage('assets/images/send.png'),
            ),
            SizedBox(width: 12.h),
            CustomText(
              text: title,
              color: btnTextColor,
              fontSized: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ],
        )),
      ),
    );
  }
}
