import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';

class FullScreenTimeslotViewer extends StatelessWidget {
  final Map<String, String> timeslot;

  const FullScreenTimeslotViewer({super.key, required this.timeslot});

  @override
  Widget build(BuildContext context) {
    final startTime = timeslot['startTime'] ?? 'N/A';
    final endTime = timeslot['endTime'] ?? 'N/A';
    final date = timeslot['date'] ?? 'N/A';
    final timeslotId = timeslot['id'] ?? 'N/A';

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: const CustomText(
          text: 'Timeslot Details',
          fontSized: 18.0,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(20.w),
          padding: EdgeInsets.all(30.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Clock Icon
              Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.access_time,
                  size: 40.w,
                  color: AppColors.backgroundColor,
                ),
              ),
              SizedBox(height: 30.w),

              // Date
              CustomText(
                text: date,
                fontSized: 18.0,
                fontWeight: FontWeight.w600,
                color: AppColors.blackColor,
                alignment: TextAlign.center,
              ),
              SizedBox(height: 20.w),

              // Time Range
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.w),
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.schedule, color: Colors.white, size: 24.w),
                    SizedBox(width: 15.w),
                    CustomText(
                      text: '$startTime - $endTime',
                      fontSized: 24.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25.w),

              // Timeslot ID
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.w),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: CustomText(
                  text: 'Timeslot ID: $timeslotId',
                  fontSized: 14.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
