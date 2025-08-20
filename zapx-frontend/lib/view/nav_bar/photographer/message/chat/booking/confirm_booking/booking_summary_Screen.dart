import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_app_bar.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_button.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/view/nav_bar/user/message/chat/chat_screen.dart';
import 'package:zapxx/view/nav_bar/user/profile/current_user/saved_photographer/booking/widgets/summary_row_item_widget.dart';

class BookingSummaryScreen extends StatefulWidget {
  const BookingSummaryScreen({super.key});

  @override
  State<BookingSummaryScreen> createState() => _BookingSummaryScreenState();
}

class _BookingSummaryScreenState extends State<BookingSummaryScreen> {
  TextEditingController otherNotesController = TextEditingController();
  final String description =
      'Here is the description of the booking lorem ipsum';
  final String addNotes = 'be on time';
  final List<String> images = [
    'assets/images/gallery1.png',
    'assets/images/gallery2.png',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: const CustomAppBar(title: 'Booking Summary'),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 23.w),
              Padding(
                padding: EdgeInsets.only(left: 24.w, bottom: 24.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      radius: 28,
                      child: Image.asset('assets/images/profile_picture.png'),
                    ),
                    SizedBox(width: 16.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 130.w,
                          child: CustomText(
                            text: 'Ethan Walker',
                            fontSized: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.blackColor,
                            textOverflow: TextOverflow.ellipsis,
                            alignment: TextAlign.start,
                          ),
                        ),
                        CustomText(
                          text: 'Canada',
                          color: AppColors.greyColor.withOpacity(0.6),
                          fontSized: 12.sp,
                          alignment: TextAlign.start,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: 327.w,
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  border: Border.all(
                    width: 1.w,
                    color: AppColors.greyColor.withOpacity(0.1),
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20.0.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SummaryRowItem(
                        description: '1 hr 3 minutes',
                        title: 'Duration',
                        fontWeight: FontWeight.w400,
                      ),
                      SizedBox(height: 16.w),
                      const SummaryRowItem(
                        description: '05:300-06:00PM',
                        title: 'Timeslot',
                        fontWeight: FontWeight.w400,
                      ),
                      SizedBox(height: 16.w),
                      SummaryRowItem(
                        description: addNotes,
                        title: 'Notes',
                        fontWeight: FontWeight.w400,
                      ),
                      SizedBox(height: 16.w),
                      SummaryRowItem(
                        description: description,
                        title: 'Description',
                        fontWeight: FontWeight.w400,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.w),
                        child: const CustomText(
                          text: 'Example Pictures',
                          fontSized: 14.0,
                          color: AppColors.blackColor,
                          alignment: TextAlign.left,
                        ),
                      ),
                      SizedBox(
                        height: 74.w,
                        child: ListView.builder(
                          itemCount: images.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(right: 10.w),
                              width: 70.w,
                              height: 70.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: AssetImage(images[index]),
                                  fit: BoxFit.cover,
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
              SizedBox(height: 16.w),
              Container(
                width: 327.w,
                height: 124.w,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1.w,
                    color: AppColors.greyColor.withOpacity(0.1),
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    children: [
                      const SummaryRowItem(
                        description: '\$60.00',
                        title: 'Photography',
                        fontWeight: FontWeight.w500,
                      ),
                      SizedBox(height: 14.w),
                      Divider(
                        indent: 10.w,
                        endIndent: 10.w,
                        color: AppColors.greyColor.withOpacity(0.1),
                      ),
                      SizedBox(height: 12.w),
                      const SummaryRowItem(
                        description: '\$60.00',
                        title: 'Total',
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.w),
              SizedBox(height: 16.w),
              CustomButton(
                title: 'Message',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => const ChatScreen(
                            userId: '1',
                            id: '1',
                            name: 'Grace',
                            image: 'assets/images/profile_picture.png',
                          ),
                    ),
                  );
                },
                btnColor: AppColors.backgroundColor,
                btnTextColor: AppColors.whiteColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
