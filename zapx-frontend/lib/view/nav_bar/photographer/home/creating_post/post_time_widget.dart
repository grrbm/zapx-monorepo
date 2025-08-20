import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_button.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';

class PostTimePicker extends StatefulWidget {
  final Function(Map<String, TimeOfDay>)
  onTimeSelected; // Callback to return the time range

  const PostTimePicker({Key? key, required this.onTimeSelected})
    : super(key: key);

  @override
  _PostTimePickerState createState() => _PostTimePickerState();
}

class _PostTimePickerState extends State<PostTimePicker> {
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      backgroundColor: AppColors.whiteColor,
      child: Container(
        height: 250.h,
        width: 300.h,
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CustomText(
              text: "Set Availability",
              color: AppColors.blackColor,
              fontSized: 16.sp,
              fontWeight: FontWeight.w600,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Start Time Picker
                Column(
                  children: [
                    CustomText(
                      text: "Start time",
                      color: AppColors.blackColor,
                      fontSized: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    5.verticalSpace,
                    Container(
                      height: 55.h,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 5.h,
                      ),
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
                        is24HourMode: false, // Set to 12-hour mode
                        onTimeChange: (time) {
                          setState(() {
                            startTime = TimeOfDay.fromDateTime(time);
                          });
                        },
                      ),
                    ),
                  ],
                ),
                // End Time Picker
                Column(
                  children: [
                    CustomText(
                      text: "End time",
                      color: AppColors.blackColor,
                      fontSized: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    5.verticalSpace,
                    Container(
                      height: 55.h,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 5.h,
                      ),
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
                        is24HourMode: false, // Set to 12-hour mode
                        onTimeChange: (time) {
                          setState(() {
                            endTime = TimeOfDay.fromDateTime(time);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Action Buttons
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
                    if (startTime != null && endTime != null) {
                      widget.onTimeSelected({
                        "start": startTime!,
                        "end": endTime!,
                      });
                      Navigator.pop(context);
                    } else {
                      // Show an error if time is not selected
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Please select both start and end times.",
                          ),
                        ),
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
}
