import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapxx/configs/app_url.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_app_bar.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/configs/date_format.dart';
import 'package:zapxx/view/nav_bar/user/booking/booking_model.dart';
import 'package:zapxx/view/nav_bar/user/message/chat/booking/all_booking/booking_details/widgets/booking_cancel_widget.dart';
import 'package:zapxx/view/nav_bar/user/message/chat/booking/all_booking/booking_details/widgets/text_column_widget.dart';

class BookingDetailsScreen extends StatefulWidget {
  final Booking? booking;
  const BookingDetailsScreen({super.key, this.booking});

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
            Divider(thickness: 1.w, height: 5),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 11.w),
                  BookingCancelWidget(
                    booking: widget.booking,
                    status:
                        widget.booking!.status ==
                                'AWAITING_BOOKING_CONFIRMATION'
                            ? 'PENDING'
                            : widget.booking!.status == 'INPROGRESS'
                            ? 'CONFIRMED'
                            : widget.booking!.status,
                  ),
                  SizedBox(height: 11.w),
                  TextColumnWidget(
                    title: 'Notes',
                    description:
                        widget.booking!.notes.isNotEmpty
                            ? widget.booking!.notes
                            : 'No notes provided.',
                  ),
                  SizedBox(height: 11.w),
                  TextColumnWidget(
                    title: 'Description',
                    description:
                        widget.booking!.description.isNotEmpty
                            ? widget.booking!.description
                            : 'No description provided.',
                  ),
                  SizedBox(height: 11.w),
                  Container(
                    width: 343.w,
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 11,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: 'Example Pictures',
                            fontSized: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.blackColor,
                          ),
                          SizedBox(height: 8.h),
                          SizedBox(
                            height: 71.w,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: widget.booking!.exampleImages.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(right: 8.w),
                                  child: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Dialog(
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(7.r),
                                              child: Image.network(
                                                AppUrl.baseUrl +
                                                    "/" +
                                                    widget
                                                        .booking!
                                                        .exampleImages[index]
                                                        .url,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(7.r),
                                      child: Image.network(
                                        AppUrl.baseUrl +
                                            "/" +
                                            widget
                                                .booking!
                                                .exampleImages[index]
                                                .url,
                                        width: 71.w,
                                        height: 71.w,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 11.w),
                  TextColumnWidget(
                    title: 'Picture Delivery',
                    description: formatDate(
                      widget.booking!.deliveryDate.toString(),
                    ),
                  ),
                  SizedBox(height: 11.w),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
