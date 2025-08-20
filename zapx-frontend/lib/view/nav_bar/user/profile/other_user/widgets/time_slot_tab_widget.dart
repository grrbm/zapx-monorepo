import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_button.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/view/nav_bar/user/home/services/widgets/scheduler_type_model.dart';
import 'package:zapxx/view/nav_bar/user/profile/current_user/saved_photographer/booking/booking_screen.dart';

class TimeSlotTabWidget extends StatefulWidget {
  final List<SchedulerDate>? timeSlots;
  final int sellerId;
  const TimeSlotTabWidget({
    super.key,
    required this.timeSlots,
    required this.sellerId,
  });

  @override
  State<TimeSlotTabWidget> createState() => _TimeSlotTabWidgetState();
}

class _TimeSlotTabWidgetState extends State<TimeSlotTabWidget> {
  TimeSlot? selectedSlot;

  @override
  Widget build(BuildContext context) {
    if (widget.timeSlots == null || widget.timeSlots!.isEmpty) {
      return const Center(child: Text('No time slots available'));
    }

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...widget.timeSlots!.map(
              (schedulerDate) => _buildDateSection(schedulerDate),
            ),
            SizedBox(height: 30.w),
            Center(
              child: CustomButton(
                title: 'View Details',
                onPressed:
                    selectedSlot == null
                        ? () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please select a time slot'),
                            ),
                          );
                        }
                        : () {
                          print(selectedSlot!.startTime);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => BookingScreen(
                                    selectedSlot: selectedSlot,
                                    sellerId: widget.sellerId,
                                  ),
                            ),
                          );
                        },
                btnColor: AppColors.backgroundColor,
                btnTextColor: AppColors.whiteColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSection(SchedulerDate date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.w),
        CustomText(
          text: DateFormat('EEEE, MMMM d').format(date.date),
          fontSized: 16.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.blackColor,
        ),
        SizedBox(height: 8.w),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.w,
          children: date.times.map((slot) => _timeSlotChip(slot)).toList(),
        ),
      ],
    );
  }

  Widget _timeSlotChip(TimeSlot slot) {
    final isSelected = selectedSlot?.id == slot.id;
    final duration = _calculateDuration(slot);
    final timeRange = _formatTimeRange(slot);

    return GestureDetector(
      onTap: () => setState(() => selectedSlot = isSelected ? null : slot),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 8.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color:
                isSelected ? AppColors.backgroundColor : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          color: isSelected ? AppColors.backgroundColor.withOpacity(0.1) : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              timeRange,
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.blackColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 4.w),
            Text(
              duration,
              style: TextStyle(fontSize: 10.sp, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimeRange(TimeSlot slot) {
    final start = DateFormat('h:mm a').format(slot.startTime);
    final end = DateFormat('h:mm a').format(slot.endTime);
    return '$start - $end';
  }

  String _calculateDuration(TimeSlot slot) {
    final difference = slot.endTime.difference(slot.startTime);
    final hours = difference.inHours;
    final minutes = difference.inMinutes.remainder(60);

    String duration = '';
    if (hours > 0) duration += '${hours}hr ';
    if (minutes > 0) duration += '${minutes}m';
    return duration.trim();
  }
}
