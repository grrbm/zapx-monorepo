import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/view/nav_bar/user/home/services/widgets/scheduler_type_model.dart';

class AvailableSlots extends StatefulWidget {
  const AvailableSlots({super.key, required this.timeScheduler});
  final ServiceSchedulerType timeScheduler;

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
          Row(
            // spacing: 8.w,
            // runSpacing: 4.w,
            children: [
              ...widget.timeScheduler.schedulerDates!.map(
                (schedulerDate) =>
                    _slotContainer(schedulerDate.date.toString()),
              ),
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
