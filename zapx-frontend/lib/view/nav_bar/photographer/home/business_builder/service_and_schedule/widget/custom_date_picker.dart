import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/view/nav_bar/photographer/home/business_builder/service_and_schedule/widget/custom_time_picker.dart';

class CustomDialogBox extends StatefulWidget {
  const CustomDialogBox({super.key});

  @override
  State<CustomDialogBox> createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  List<Map<String, TimeOfDay>> selectedTimeSlots = [];
  List<Map<String, dynamic>> availabilityList = [];
  void addToAvailabilityList(
    DateTime selectedDate,
    List<Map<String, TimeOfDay>> timeSlots,
  ) {
    final formattedDate = selectedDate.toUtc().toIso8601String();
    final formattedTimeSlots =
        timeSlots.map((slot) {
          return {
            "startTime":
                _convertToDateTime(
                  slot['start']!,
                  selectedDate,
                ).toIso8601String(),
            "endTime":
                _convertToDateTime(
                  slot['end']!,
                  selectedDate,
                ).toIso8601String(),
          };
        }).toList();

    setState(() {
      // Check if the date already exists
      final existingEntryIndex = availabilityList.indexWhere(
        (entry) => entry['date'] == formattedDate,
      );

      if (existingEntryIndex != -1) {
        // If the date exists, add the new time slots to its times list
        availabilityList[existingEntryIndex]['times'].addAll(
          formattedTimeSlots,
        );
      } else {
        // If the date does not exist, create a new entry
        availabilityList.add({
          "date": formattedDate,
          "times": formattedTimeSlots,
        });
      }
    });
  }

  List<Map<String, String>> getApiFormattedTimeRanges(
    List<Map<String, TimeOfDay>> timeRanges,
    DateTime selectedDate,
  ) {
    return timeRanges.map((range) {
      final startTime = _convertToDateTime(range['start']!, selectedDate);
      final endTime = _convertToDateTime(range['end']!, selectedDate);

      return {
        "startTime": startTime.toIso8601String(),
        "endTime": endTime.toIso8601String(),
      };
    }).toList();
  }

  // Helper method to convert TimeOfDay to DateTime in UTC
  DateTime _convertToDateTime(TimeOfDay time, DateTime selectedDate) {
    return DateTime.utc(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      time.hour,
      time.minute,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      backgroundColor: AppColors.whiteColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          20.verticalSpace,
          CustomText(
            text: "Date",
            color: AppColors.blackColor,
            fontSized: 18.sp,
            fontWeight: FontWeight.w600,
          ),
          Container(
            height: 400.0, // Custom height
            width: 330.0, // Custom width
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              color: AppColors.whiteColor,
            ),
            child: Center(
              child: SfDateRangePicker(
                selectionMode: DateRangePickerSelectionMode.single,
                initialSelectedRange: PickerDateRange(
                  DateTime.now().subtract(const Duration(days: 4)),
                  DateTime.now().add(const Duration(days: 3)),
                ),
                backgroundColor: AppColors.whiteColor,
                todayHighlightColor: AppColors.backgroundColor,
                rangeSelectionColor: AppColors.backgroundColor,
                startRangeSelectionColor: AppColors.backgroundColor,
                endRangeSelectionColor: AppColors.backgroundColor,
                showActionButtons: true,
                rangeTextStyle: const TextStyle(color: Colors.white),
                selectionTextStyle: const TextStyle(color: Colors.white),
                headerHeight: 50.h,
                enablePastDates: false,
                headerStyle: DateRangePickerHeaderStyle(
                  backgroundColor: AppColors.whiteColor,
                  textAlign: TextAlign.center,
                  textStyle: TextStyle(
                    color: AppColors.blackColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                selectionShape: DateRangePickerSelectionShape.rectangle,
                onCancel: () {
                  Navigator.pop(context);
                },
                onSubmit: (a) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return CustomTimePicker(
                        onTimeSelected: (timeSlots) async {
                          await Future.delayed(
                            const Duration(milliseconds: 100),
                          );
                          if (timeSlots.isNotEmpty) {
                            addToAvailabilityList(a as DateTime, timeSlots);
                          }
                          print(timeSlots);
                          print(availabilityList);

                          Navigator.pop(context, availabilityList);
                          // Handle the selected time range here
                        },
                      );
                    },
                  );
                  print(a);
                },
                confirmText: "Apply",
                cancelText: "Cancel",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
