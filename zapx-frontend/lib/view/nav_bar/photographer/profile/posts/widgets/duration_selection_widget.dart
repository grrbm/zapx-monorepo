import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';

class DurationSelection extends StatefulWidget {
  const DurationSelection({super.key});

  @override
  State<DurationSelection> createState() => _DurationSelectionState();
}

class _DurationSelectionState extends State<DurationSelection> {
  String selectedDuration = '1 hr 30 mins'; // Default selected duration

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.w),
          CustomText(
            text: 'Choose Duration',
            fontSized: 16.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.blackColor,
          ),
          SizedBox(height: 4.w),
          Wrap(
            spacing: 8.w,
            runSpacing: 4.w, // Adjust this to add space between rows if needed
            children: [
              _durationContainer('45 mins'),
              _durationContainer('15 mins'),
              _durationContainer('1 hr'),
              _durationContainer('1 hr 30 mins'),
            ],
          ),
          SizedBox(height: 16.w),
        ],
      ),
    );
  }

  Widget _durationContainer(String title) {
    bool isSelected = selectedDuration == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDuration = title;
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
              text: title,
              fontSized: 12.sp,
              color: AppColors.blackColor,
            ),
          ],
        ),
      ),
    );
  }
}
