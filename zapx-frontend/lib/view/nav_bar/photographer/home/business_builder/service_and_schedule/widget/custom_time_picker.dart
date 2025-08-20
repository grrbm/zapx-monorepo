import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_button.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/configs/utils.dart';

class CustomTimePicker extends StatefulWidget {
  const CustomTimePicker({Key? key, required this.onTimeSelected})
    : super(key: key);
  final Function(List<Map<String, TimeOfDay>>) onTimeSelected;

  @override
  State<CustomTimePicker> createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  List<Map<String, TimeOfDay>> timeSlots = [];

  void addTimeSlot() {
    if (startTime != null && endTime != null) {
      setState(() {
        timeSlots.add({"start": startTime!, "end": endTime!});
        startTime = null;
        endTime = null;
      });
    } else {
      Utils.flushBarErrorMessage(
        "Please select both start and end times.",
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      backgroundColor: AppColors.whiteColor,
      child: Container(
        height: 400.h,
        width: 300.h,
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomText(
              text: "Set Availability",
              color: AppColors.blackColor,
              fontSized: 16.sp,
              fontWeight: FontWeight.w600,
            ),
            10.verticalSpace,
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildTimePicker("Start time", (time) {
                  setState(() {
                    startTime = TimeOfDay.fromDateTime(time);
                  });
                }),
                buildTimePicker("End time", (time) {
                  setState(() {
                    endTime = TimeOfDay.fromDateTime(time);
                  });
                }),
              ],
            ),
            10.verticalSpace,
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: addTimeSlot,
                child: CustomText(
                  text: "+ Set multiple Availabilities",
                  color: AppColors.backgroundColor,
                  fontSized: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            Expanded(
              child: ListView.builder(
                itemCount: timeSlots.length,
                itemBuilder: (context, index) {
                  final slot = timeSlots[index];
                  return ListTile(
                    title: Text(
                      "Start: ${formatTime(slot['start']!)} - End: ${formatTime(slot['end']!)}",
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          timeSlots.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButton(
                  title: "Cancel",
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  btnColor: AppColors.whiteColor,
                  btnTextColor: AppColors.redColor,
                  borderRadius: 20,
                  width: 120.w,
                  height: 35.h,
                ),
                CustomButton(
                  title: "Apply",
                  onPressed: () {
                    if (timeSlots.isNotEmpty) {
                      widget.onTimeSelected(timeSlots);
                      Navigator.pop(context);
                    } else {
                      Utils.flushBarErrorMessage(
                        "Please add at least one time slot.",
                        context,
                      );
                    }
                  },
                  btnColor: AppColors.backgroundColor,
                  btnTextColor: AppColors.whiteColor,
                  borderRadius: 20,
                  width: 120.w,
                  height: 35.h,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTimePicker(String label, Function(DateTime) onTimeChange) {
    return Column(
      children: [
        CustomText(
          text: label,
          color: AppColors.blackColor,
          fontSized: 16.sp,
          fontWeight: FontWeight.w600,
        ),
        5.verticalSpace,
        Container(
          height: 55.h,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.r),
            color: AppColors.lightGreyColor,
          ),
          alignment: Alignment.topCenter,
          child: TimePickerSpinner(
            normalTextStyle: TextStyle(
              fontSize: 16.sp,
              color: AppColors.backgroundColor.withOpacity(0.5),
            ),
            highlightedTextStyle: TextStyle(
              fontSize: 16.sp,
              color: AppColors.blackColor,
            ),
            spacing: 0,
            itemHeight: 22,
            isForce2Digits: true,
            alignment: Alignment.topCenter,
            is24HourMode: false,
            onTimeChange: onTimeChange,
          ),
        ),
      ],
    );
  }

  String formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? "AM" : "PM";
    return "$hour:$minute $period";
  }
}
