import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_button.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';

class PhotoshootReminderDialog extends StatelessWidget {
  const PhotoshootReminderDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        height: 370.w,
        width: 283.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CustomText(
                  text: "Photoshoot Reminder1",
                  fontSized: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal, // Teal color like in the image
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Icon(Icons.close, color: Colors.black),
                ),
              ],
            ),
            SizedBox(height: 20.w),

            // Description title
            const CustomText(
              text: "Description",
              fontSized: 26.0,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
            SizedBox(height: 10.w),

            // Description content
            const CustomText(
              text:
                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever.",
              fontSized: 14.0,
              color: Colors.black54, // Slightly dimmed black
              alignment: TextAlign.center,
            ),
            const Spacer(),

            CustomButton(
              title: 'View Details',
              onPressed: () {},
              btnColor: AppColors.backgroundColor,
              btnTextColor: AppColors.whiteColor,
            ),

            const SizedBox(height: 10),

            // Close Button
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.r),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 12,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 65.w, vertical: 7.w),
                child: const CustomText(
                  text: "Close",
                  fontSized: 14.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
