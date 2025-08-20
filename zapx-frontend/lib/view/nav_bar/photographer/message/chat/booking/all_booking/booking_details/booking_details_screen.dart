import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_app_bar.dart';
import 'package:zapxx/view/nav_bar/user/message/chat/booking/all_booking/booking_details/widgets/booking_cancel_widget.dart';
import 'package:zapxx/view/nav_bar/user/message/chat/booking/all_booking/booking_details/widgets/example_picture_widget.dart';
import 'package:zapxx/view/nav_bar/user/message/chat/booking/all_booking/booking_details/widgets/text_column_widget.dart';

class BookingDetailsScreen extends StatefulWidget {
  const BookingDetailsScreen({super.key});

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  int selectedIndex = 0;
  final List<String> images = [
    'assets/images/gallery1.png',
    'assets/images/gallery2.png',
    'assets/images/gallery3.png',
    'assets/images/gallery4.png',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: const CustomAppBar(title: 'Booking Details'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Divider(
              thickness: 1.w,
              height: 5,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 11.w,
                  ),
                  const BookingCancelWidget(
                    status: 'Confirmed',
                  ),
                  SizedBox(
                    height: 11.w,
                  ),
                  const TextColumnWidget(
                    title: 'Notes',
                    description:
                        'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                  ),
                  SizedBox(
                    height: 11.w,
                  ),
                  const TextColumnWidget(
                    title: 'Description',
                    description:
                        'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever.',
                  ),
                  SizedBox(
                    height: 11.w,
                  ),
                  ExamplePictureWidget(
                    title: 'Example Pictures',
                    images: images,
                  ),
                  SizedBox(
                    height: 11.w,
                  ),
                  const TextColumnWidget(
                    title: 'Picture Delivery',
                    description: 'October 24, 2023',
                  ),
                  SizedBox(
                    height: 11.w,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
