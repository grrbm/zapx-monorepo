import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_button.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/view/nav_bar/user/booking/booking_model.dart';
import 'package:zapxx/view/nav_bar/user/message/chat/booking/all_booking/booking_details/booking_details_screen.dart';

class PhotoshootReminderDialog extends StatelessWidget {
  final Booking booking;

  const PhotoshootReminderDialog({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        height: 270.w,
        width: 283.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CustomText(
                  text: "Photoshoot Reminder",
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
            CustomText(
              text: booking.description,
              fontSized: 26.0,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
            SizedBox(height: 10.w),

            // Description content
            CustomText(
              text: booking.notes,
              fontSized: 14.0,
              color: Colors.black54, // Slightly dimmed black
              alignment: TextAlign.center,
            ),
            SizedBox(height: 20.w),
            CustomButton(
              title: 'View Details',
              onPressed: () {
                // Navigate to booking details screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => BookingDetailsScreen(booking: booking),
                  ),
                );
              },
              btnColor: AppColors.backgroundColor,
              btnTextColor: AppColors.whiteColor,
            ),
          ],
        ),
      ),
    );
  }
}
