import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_app_bar.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_button.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/view/nav_bar/user/message/chat/booking/all_booking/all_booking_screen.dart';
import 'package:zapxx/view/nav_bar/user/message/chat/booking/confirm_booking/widgets/confirm_booking_input_text_field.dart';
import 'package:zapxx/view/nav_bar/user/profile/current_user/saved_photographer/booking/widgets/summary_row_item_widget.dart';

class ConfirmBookingSummaryScreen extends StatefulWidget {
  const ConfirmBookingSummaryScreen({super.key});

  @override
  State<ConfirmBookingSummaryScreen> createState() =>
      _ConfirmBookingSummaryScreenState();
}

class _ConfirmBookingSummaryScreenState
    extends State<ConfirmBookingSummaryScreen> {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 23.w,
              ),
              Container(
                width: 327.w,
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  border: Border.all(
                      width: 1.w, color: AppColors.greyColor.withOpacity(0.1)),
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
                      SizedBox(
                        height: 16.w,
                      ),
                      const SummaryRowItem(
                        description: '05:300-06:00PM',
                        title: 'Timeslot',
                        fontWeight: FontWeight.w400,
                      ),
                      SizedBox(
                        height: 16.w,
                      ),
                      SummaryRowItem(
                        description: addNotes,
                        title: 'Notes',
                        fontWeight: FontWeight.w400,
                      ),
                      SizedBox(
                        height: 16.w,
                      ),
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
                            }),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 16.w,
              ),
              Container(
                width: 327.w,
                height: 124.w,
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 1.w, color: AppColors.greyColor.withOpacity(0.1)),
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
                      SizedBox(
                        height: 14.w,
                      ),
                      Divider(
                        indent: 10.w,
                        endIndent: 10.w,
                        color: AppColors.greyColor.withOpacity(0.1),
                      ),
                      SizedBox(
                        height: 12.w,
                      ),
                      const SummaryRowItem(
                        description: '\$60.00',
                        title: 'Total',
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 16.w,
              ),
              Container(
                width: 327.w,
                height: 72.w,
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 1.w, color: AppColors.greyColor.withOpacity(0.1)),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image(
                              width: 24.w,
                              height: 24.w,
                              image:
                                  const AssetImage('assets/images/paypal.png')),
                          SizedBox(
                            width: 16.w,
                          ),
                          SizedBox(
                            width: 189.w,
                            height: 25,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Image(
                                  width: 45.w,
                                  height: 45.w,
                                  image: const AssetImage(
                                      'assets/images/paypal_text.png')),
                            ),
                          ),
                          SizedBox(
                            width: 4.w,
                          ),
                          const CustomText(
                            text: 'Change',
                            fontSized: 14.0,
                            fontWeight: FontWeight.w600,
                            color: AppColors.backgroundColor,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 16.w,
              ),
              const CustomText(
                text: 'Add other Notes',
                alignment: TextAlign.start,
                fontSized: 14.0,
                fontWeight: FontWeight.w600,
                color: AppColors.blackColor,
              ),
              SizedBox(
                height: 8.w,
              ),
              SizedBox(
                width: 327.w,
                child: ConfirmBookingInputTextField(
                  height: 60.w,
                  maxLines: 2,
                  controller: otherNotesController,
                ),
              ),
              SizedBox(
                height: 16.w,
              ),
              CustomButton(
                  title: 'Confirm Booking',
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AllBookingScreen()));
                  },
                  btnColor: AppColors.backgroundColor,
                  btnTextColor: AppColors.whiteColor)
            ],
          ),
        ),
      ),
    );
  }
}
