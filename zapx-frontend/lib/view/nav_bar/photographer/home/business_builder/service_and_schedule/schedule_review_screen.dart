import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_app_bar.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_button.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';

class ScheduleReviewScreen extends StatefulWidget {
  const ScheduleReviewScreen({super.key});

  @override
  State<ScheduleReviewScreen> createState() => _ScheduleReviewScreenState();
}

class _ScheduleReviewScreenState extends State<ScheduleReviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(
        title: 'Schedule Review',
        leadingIcon: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Divider(
              thickness: 1,
            ),
            5.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  10.verticalSpace,
                  SizedBox(
                    height: 100.h * 5,
                    child: ListView.separated(
                      itemCount: 5, // Number of items in the list
                      separatorBuilder: (context, index) => 15.verticalSpace,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomText(
                                  text: "Monday",
                                  color: AppColors.greyColor1,
                                  fontSized: 12.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                                // const Icon(Icons.edit_calendar_outlined),
                                Image.asset(
                                  'assets/images/edit.png',
                                  height: 20.h,
                                  width: 20.w,
                                ),
                              ],
                            ),
                            10.verticalSpace,
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                color: const Color(0xffecf6f9),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                                vertical: 10.h,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        text: "Time Slot",
                                        color: AppColors.blackColor,
                                        fontSized: 12.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      6.verticalSpace,
                                      CustomText(
                                        text: "10:00 AM - 11:00 AM",
                                        color: AppColors.greyColor1,
                                        fontSized: 12.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      6.verticalSpace,
                                      CustomText(
                                        text: "10:00 AM - 11:00 AM",
                                        color: AppColors.greyColor1,
                                        fontSized: 12.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      6.verticalSpace,
                                      CustomText(
                                        text: "10:00 AM - 11:00 AM",
                                        color: AppColors.greyColor1,
                                        fontSized: 12.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        text: "Duration",
                                        color: AppColors.blackColor,
                                        fontSized: 12.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      6.verticalSpace,
                                      CustomText(
                                        text: "1 hour",
                                        color: AppColors.greyColor1,
                                        fontSized: 12.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      6.verticalSpace,
                                      CustomText(
                                        text: "1 hour",
                                        color: AppColors.greyColor1,
                                        fontSized: 12.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      6.verticalSpace,
                                      CustomText(
                                        text: "1 hour",
                                        color: AppColors.greyColor1,
                                        fontSized: 12.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        text: "Price",
                                        color: AppColors.blackColor,
                                        fontSized: 12.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      6.verticalSpace,
                                      CustomText(
                                        text: "25/hr",
                                        color: AppColors.greyColor1,
                                        fontSized: 12.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      6.verticalSpace,
                                      CustomText(
                                        text: "24/hr",
                                        color: AppColors.greyColor1,
                                        fontSized: 12.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      6.verticalSpace,
                                      CustomText(
                                        text: "24/hr",
                                        color: AppColors.greyColor1,
                                        fontSized: 12.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  10.verticalSpace,
                  CustomButton(
                    title: "Save Changes",
                    onPressed: () {},
                    btnColor: AppColors.backgroundColor,
                    btnTextColor: AppColors.whiteColor,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
