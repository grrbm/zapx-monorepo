import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';

class DateDialogBox extends StatefulWidget {
  const DateDialogBox({super.key});

  @override
  State<DateDialogBox> createState() => _DateDialogBoxState();
}

class _DateDialogBoxState extends State<DateDialogBox> {
  PickerDateRange? _selectedRange;
  void _applyFilters() {
    final filters = {
      if (_selectedRange!.startDate != null)
        'timeFrom': _selectedRange!.startDate!.toUtc().toString(),
      if (_selectedRange!.endDate != null)
        'timeTo': _selectedRange!.endDate!.toUtc().toString(),
    };

    // Clear filters if all values are empty
    if (filters.isEmpty) {
      Navigator.pop(context, {});
    } else {
      Navigator.pop(context, filters);
    }
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
            height: 400.0,
            width: 330.0,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              color: AppColors.whiteColor,
            ),
            child: Center(
              child: SfDateRangePicker(
                selectionMode: DateRangePickerSelectionMode.range,

                onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                  setState(() {
                    _selectedRange = args.value;
                  });
                },
                backgroundColor: AppColors.whiteColor,
                todayHighlightColor: AppColors.backgroundColor,
                rangeSelectionColor: AppColors.backgroundColor,
                startRangeSelectionColor: AppColors.backgroundColor,
                endRangeSelectionColor: AppColors.backgroundColor,
                showActionButtons: true,
                rangeTextStyle: const TextStyle(color: Colors.white),
                selectionTextStyle: const TextStyle(color: Colors.white),
                headerHeight: 50.h,
                enablePastDates: true,
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
                  _applyFilters();
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
