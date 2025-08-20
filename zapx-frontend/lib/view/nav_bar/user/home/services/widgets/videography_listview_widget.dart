import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapxx/configs/app_url.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/model/single_post_model.dart';
import 'package:zapxx/view/nav_bar/user/home/services/services_scheduler.dart';
import 'package:zapxx/view/nav_bar/user/profile/other_user/other_user_profile_screen.dart';
import 'package:intl/intl.dart';

class VideographyListviewWidget extends StatelessWidget {
  final SinglePostModel? singlePostModel;
  final List<ServiceScheduler> services;

  const VideographyListviewWidget({
    super.key,
    required this.services,
    this.singlePostModel,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: services.length,
      scrollDirection: Axis.vertical,
      physics: const ScrollPhysics(parent: NeverScrollableScrollPhysics()),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final service = services[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => OtherUserProfileScreen(
                      scheduler: service,
                      //  userId: service.seller.user.id,
                    ),
              ),
            );
          },
          child: Container(
            width: 327.w,
            // Remove fixed height so card grows with content
            margin: EdgeInsets.only(bottom: 10.w),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              border: Border.all(color: AppColors.greyColor.withOpacity(0.1)),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(14.w),
                  child: Container(
                    width: 81.w,
                    height: 107.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: Image(
                        width: 84.w,
                        height: 107.w,
                        fit: BoxFit.cover,
                        image:
                            service.seller.user.profileImage != null
                                ? NetworkImage(
                                  AppUrl.baseUrl +
                                      '/' +
                                      service.seller.user.profileImage!.url,
                                )
                                : const AssetImage('assets/images/gallery4.png')
                                    as ImageProvider,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 10.w,
                      horizontal: 4.w,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomText(
                              text: service.seller.user.fullName,
                              fontSized: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.blackColor,
                            ),
                            SizedBox(width: 4.w),
                            Image(
                              width: 19.h,
                              height: 19.h,
                              image: const AssetImage(
                                'assets/images/verify.png',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.w),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image(
                              height: 12.w,
                              width: 12.w,
                              image: const AssetImage('assets/images/star.png'),
                            ),
                            SizedBox(width: 5.h),
                            CustomText(
                              text:
                                  service.averageRating == null
                                      ? '0.0'
                                      : service.averageRating.toString(),
                              fontSized: 12.0,
                              fontWeight: FontWeight.w700,
                              color: AppColors.blackColor,
                            ),
                            SizedBox(width: 2.h),
                            CustomText(
                              text: '(${service.seller.reviewCount})',
                              fontSized: 12.0,
                              fontWeight: FontWeight.w700,
                              color: AppColors.greyColor.withOpacity(0.5),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.w),
                        // Show all available time slots with their rates
                        if (service.schedulerDate.isNotEmpty)
                          ...service.schedulerDate
                              .map(
                                (date) => Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: 'Date: 	${date.date.split('T')[0]}',
                                      fontSized: 12.0,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.blackColor,
                                    ),
                                    SizedBox(height: 2.w),
                                    ...date.time
                                        .map(
                                          (slot) => Container(
                                            margin: EdgeInsets.only(
                                              bottom: 4.w,
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8.w,
                                              vertical: 4.w,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.greyColor
                                                  .withOpacity(0.08),
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.access_time,
                                                  size: 14,
                                                  color:
                                                      AppColors.backgroundColor,
                                                ),
                                                SizedBox(width: 4.w),
                                                CustomText(
                                                  text:
                                                      '${DateFormat('hh:mm a').format(DateFormat('yyyy-MM-ddTHH:mm:ss').parse(slot.startTime, true).toLocal())} - ${DateFormat('hh:mm a').format(DateFormat('yyyy-MM-ddTHH:mm:ss').parse(slot.endTime, true).toLocal())}',
                                                  fontSized: 11.0,
                                                  color: AppColors.blackColor,
                                                ),
                                                SizedBox(width: 10.w),
                                                Icon(
                                                  Icons.attach_money,
                                                  size: 14,
                                                  color:
                                                      AppColors.backgroundColor,
                                                ),
                                                CustomText(
                                                  text: '${slot.rate}',
                                                  fontSized: 11.0,
                                                  color: AppColors.blackColor,
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    SizedBox(height: 6.w),
                                  ],
                                ),
                              )
                              .toList(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPriceContainer(String text) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        border: Border.all(color: AppColors.greyColor.withOpacity(0.1)),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.w),
        child: CustomText(
          text: text,
          fontSized: 10.0,
          color: AppColors.blackColor,
        ),
      ),
    );
  }
}
