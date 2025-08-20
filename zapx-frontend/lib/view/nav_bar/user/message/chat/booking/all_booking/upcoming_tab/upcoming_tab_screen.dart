import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/view/nav_bar/user/message/chat/booking/all_booking/widgets/booking_status_widget.dart';
import 'package:zapxx/view/nav_bar/user/booking/booking_model.dart';

class UpcomingTabScreen extends StatelessWidget {
  final List<Booking> bookings;
  const UpcomingTabScreen({super.key, required this.bookings});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16.w),
            child: const CustomText(
              text: 'Upcoming',
              fontSized: 16.0,
              fontWeight: FontWeight.w700,
              alignment: TextAlign.start,
            ),
          ),
          SizedBox(height: 3.w),
          Expanded(
            child:
                bookings.isEmpty
                    ? Center(child: Text('No upcoming bookings'))
                    : ListView.builder(
                      itemCount: bookings.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: 22.w,
                            left: 16.w,
                            right: 16.w,
                          ),
                          child: BookingStatusWidget(
                            status: bookings[index].status,
                            booking: bookings[index],
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
