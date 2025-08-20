import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/view/nav_bar/user/message/chat/booking/all_booking/widgets/booking_status_widget.dart';

class PastTabScreen extends StatelessWidget {
  const PastTabScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16.w),
            child: const CustomText(
              text: 'Active',
              fontSized: 16.0,
              fontWeight: FontWeight.w700,
              alignment: TextAlign.start,
            ),
          ),
          SizedBox(
            height: 3.w,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: 2,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        EdgeInsets.only(bottom: 22.w, left: 16.w, right: 16.w),
                    child: const BookingStatusWidget(status: 'Active'),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
