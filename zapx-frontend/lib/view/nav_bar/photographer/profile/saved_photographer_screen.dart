import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/view/nav_bar/user/profile/current_user/saved_photographer/gigs/gigs_tab.dart';
import 'package:zapxx/view/nav_bar/user/profile/current_user/saved_photographer/posts/posts_tab.dart';
import 'package:zapxx/view/nav_bar/user/profile/current_user/saved_photographer/reviews/reviews_tab.dart';
import 'package:zapxx/view/nav_bar/user/profile/current_user/saved_photographer/widgets/message_button.dart';

class SavedPhotographerScreen extends StatefulWidget {
  const SavedPhotographerScreen({super.key});

  @override
  State<SavedPhotographerScreen> createState() =>
      _SavedPhotographerScreenState();
}

class _SavedPhotographerScreenState extends State<SavedPhotographerScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
          centerTitle: true,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: AppColors.blackColor,
            ),
          ),
          title: const CustomText(
            text: 'Saved Photographer',
            fontSized: 18.0,
            fontWeight: FontWeight.w600,
            color: AppColors.blackColor,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Divider(
                thickness: 1,
              ),
              SizedBox(height: 5.h),
              Center(
                child: Container(
                  width: 80.h,
                  height: 80.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(80),
                  ),
                  child: const Image(
                      image: AssetImage('assets/images/profile_picture.png')),
                ),
              ),
              SizedBox(height: 7.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: 'Erico Movement',
                    fontSized: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.blackColor,
                  ),
                  SizedBox(width: 4.w),
                  Image(
                      width: 19.h,
                      height: 19.h,
                      image: const AssetImage('assets/images/verify.png'))
                ],
              ),
              CustomText(
                text: '@erico_mov99',
                fontSized: 14.sp,
                fontWeight: FontWeight.normal,
                color: AppColors.greyColor.withOpacity(0.5),
              ),
              SizedBox(
                height: 4.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    height: 16.w,
                    width: 16.w,
                    image: const AssetImage('assets/images/star.png'),
                  ),
                  SizedBox(
                    width: 5.h,
                  ),
                  const CustomText(
                    text: '4.4',
                    fontSized: 12.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.blackColor,
                  ),
                  SizedBox(
                    width: 2.h,
                  ),
                  CustomText(
                    text: '(87)',
                    fontSized: 12.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.greyColor.withOpacity(0.5),
                  ),
                ],
              ),
              SizedBox(
                height: 6.h,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 41.0),
                child: CustomText(
                  text:
                      'I have been a photgrapher for the past 3+ years. I am extremely passionate about it and I want to help you ',
                  fontSized: 13.0,
                  color: AppColors.blackColor,
                ),
              ),
              SizedBox(
                height: 17.h,
              ),
              MessageButton(
                title: 'Message',
                btnColor: AppColors.backgroundColor,
                btnTextColor: AppColors.whiteColor,
                onPressed: () {},
              ),
              const TabBar(
                labelColor: AppColors.blackColor,
                unselectedLabelColor: Colors.grey,
                indicatorColor: AppColors.backgroundColor,
                tabs: [
                  Tab(text: 'Reviews'),
                  Tab(text: 'Gigs'),
                  Tab(text: 'Posts'),
                ],
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.81,
                child: const TabBarView(
                  children: [
                    ReviewsTab(
                      paddingLeft: 24.0,
                    ),
                    GigsTab(),
                    PostsTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
