import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';

class AvailableSlots extends StatefulWidget {
  const AvailableSlots({super.key});

  @override
  State<AvailableSlots> createState() => _AvailableSlotsState();
}

class _AvailableSlotsState extends State<AvailableSlots> {
  String selectedSlot = '12pm - 02pm';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'Available Slots',
            fontSized: 16.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.blackColor,
          ),
          SizedBox(height: 4.w),
          Wrap(
            spacing: 8.w,
            runSpacing: 4.w,
            children: [
              _slotContainer('09am - 10am'),
              _slotContainer('09am - 11am'),
              _slotContainer('12pm - 02pm'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _slotContainer(String time) {
    bool isSelected = selectedSlot == time;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSlot = time;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 4.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color:
                isSelected ? AppColors.backgroundColor : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          color: isSelected ? AppColors.backgroundColor.withOpacity(0.1) : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppColors.backgroundColor,
                size: 16.sp,
              ),
            if (isSelected) SizedBox(width: 5.w),
            CustomText(
              text: time,
              fontSized: 12.sp,
              color: AppColors.blackColor,
            ),
          ],
        ),
      ),
    );
  }
}
