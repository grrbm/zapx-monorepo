import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_app_bar.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/view/nav_bar/photographer/message/chat/booking/confirm_booking/booking_summary_Screen.dart';

class PeopleBookedYouScreen extends StatefulWidget {
  const PeopleBookedYouScreen({super.key});

  @override
  State<PeopleBookedYouScreen> createState() => _PeopleBookedYouScreenState();
}

class _PeopleBookedYouScreenState extends State<PeopleBookedYouScreen> {
  final DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final List<Map<String, String>> bookings = [
    {"name": "Ethan Walker", "location": "Canada", "time": "08:00PM"},
    {"name": "Benjamin Cruz", "location": "Canada", "time": "08:00PM"},
    {"name": "Alexander Nguyen", "location": "Canada", "time": "08:00PM"},
    {"name": "Noah Patel", "location": "Canada", "time": "08:00PM"},
    {"name": "Lucas Thompson", "location": "Canada", "time": "08:00PM"},
    {"name": "Olivia Garcia", "location": "Canada", "time": "08:00PM"},
    {"name": "Sophia Martinez", "location": "Canada", "time": "08:00PM"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor.withOpacity(0.98),
      appBar: const CustomAppBar(title: 'People Booked You'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 30,
                      itemBuilder: (context, index) {
                        final day = _focusedDay.add(Duration(days: index));
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedDay = day;
                            });
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Container(
                              width: 45.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: _selectedDay == day
                                    ? Colors.teal
                                    : Colors.grey.withOpacity(0.1),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    DateFormat('EEE').format(day),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: _selectedDay == day
                                          ? Colors.white
                                          : Colors.grey.withOpacity(0.8),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "${day.day}",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: _selectedDay == day
                                            ? Colors.white
                                            : Colors.grey.withOpacity(0.8),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.w),

          // List of bookings
          Expanded(
            child: ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.grey[300],
                              radius: 28,
                              child: Image.asset(
                                  'assets/images/profile_picture.png'),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 130.w,
                                  child: CustomText(
                                    text: bookings[index]['name']!,
                                    fontSized: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.blackColor,
                                    textOverflow: TextOverflow.ellipsis,
                                    alignment: TextAlign.start,
                                  ),
                                ),
                                SizedBox(height: 4.w),
                                Row(
                                  children: [
                                    CustomText(
                                      text: bookings[index]['location']!,
                                      color:
                                          AppColors.greyColor.withOpacity(0.6),
                                      fontSized: 12.sp,
                                      alignment: TextAlign.start,
                                    ),
                                    CustomText(
                                      text: ' - ',
                                      color:
                                          AppColors.greyColor.withOpacity(0.6),
                                      fontSized: 12.sp,
                                    ),
                                    CustomText(
                                      text: bookings[index]['time']!,
                                      color:
                                          AppColors.greyColor.withOpacity(0.6),
                                      fontSized: 12.sp,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const BookingSummaryScreen()));
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.teal,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: CustomText(
                              text: 'View Booking',
                              color: AppColors.whiteColor,
                              fontWeight: FontWeight.w600,
                              fontSized: 12.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
