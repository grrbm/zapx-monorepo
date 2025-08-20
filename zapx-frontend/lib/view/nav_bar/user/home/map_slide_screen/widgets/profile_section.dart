import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapxx/configs/app_url.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/view/nav_bar/user/home/services/widgets/scheduler_type_model.dart';
import 'package:zapxx/view/nav_bar/user/message/chat/chat_screen.dart';

class ProfileSection extends StatelessWidget {
  const ProfileSection({
    super.key,
    required this.portfolioScheduler,
    required this.reviewCount,
    required this.average,
  });
  final ServiceSchedulerType portfolioScheduler;
  final int reviewCount;
  final String average;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Image(
                width: 24.h,
                height: 24.h,
                image: const AssetImage('assets/images/arrow_left.png'),
              ),
            ),
            Row(
              children: [
                Container(
                  width: 80.h,
                  height: 80.h,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400, width: 2),
                    shape: BoxShape.circle,
                    image:
                        portfolioScheduler.seller.user.profileImage != null
                            ? DecorationImage(
                              image: NetworkImage(
                                AppUrl.baseUrl +
                                    '/' +
                                    portfolioScheduler
                                        .seller
                                        .user
                                        .profileImage!
                                        .url,
                              ),
                              fit: BoxFit.cover,
                            )
                            : DecorationImage(
                              image: AssetImage(
                                'assets/images/profile_picture.png',
                              ),
                              fit: BoxFit.cover,
                            ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 9.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(
                            text: portfolioScheduler.seller.user.fullName,
                            fontSized: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.blackColor,
                          ),
                          SizedBox(width: 4.w),
                          Image(
                            width: 19.h,
                            height: 19.h,
                            image: const AssetImage('assets/images/verify.png'),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 9.w),
                      child: CustomText(
                        text: portfolioScheduler.seller.user.username!,
                        fontSized: 12.sp,
                        fontWeight: FontWeight.normal,
                        color: AppColors.greyColor.withOpacity(0.5),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Padding(
                      padding: EdgeInsets.only(left: 9.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            height: 12.w,
                            width: 12.w,
                            image: const AssetImage('assets/images/star.png'),
                          ),
                          SizedBox(width: 5.h),
                          CustomText(
                            text: average,
                            fontSized: 12.0,
                            fontWeight: FontWeight.w700,
                            color: AppColors.blackColor,
                          ),
                          SizedBox(width: 2.h),
                          CustomText(
                            text: '($reviewCount)',
                            fontSized: 12.0,
                            fontWeight: FontWeight.w700,
                            color: AppColors.greyColor.withOpacity(0.5),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 230.w,
                      child: CustomText(
                        text: portfolioScheduler.seller.aboutMe ?? '',
                        fontSized: 12.sp,
                        color: AppColors.blackColor,
                        alignment: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        Positioned(
          top: 50.w,
          right: 16.w,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => ChatScreen(
                        userId: portfolioScheduler.seller.user.id.toString(),
                        id:
                            portfolioScheduler.seller.user.chats?.isEmpty ??
                                    true
                                ? ''
                                : portfolioScheduler.seller.user.chats!.first.id
                                    .toString(),
                        name: portfolioScheduler.seller.user.fullName,
                        image:
                            portfolioScheduler.seller.user.profileImage != null
                                ? AppUrl.baseUrl +
                                    '/' +
                                    portfolioScheduler
                                        .seller
                                        .user
                                        .profileImage!
                                        .url
                                : '',
                      ),
                ),
              );
            },
            child: Image(
              width: 28.w,
              height: 28.w,
              color: AppColors.backgroundColor,
              image: const AssetImage('assets/images/invite_friend.png'),
            ),
          ),
        ),
      ],
    );
  }
}
