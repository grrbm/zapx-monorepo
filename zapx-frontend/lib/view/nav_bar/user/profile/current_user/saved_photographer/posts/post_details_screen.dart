import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_button.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/view/nav_bar/user/home/map_slide_screen/widgets/location_details_widget.dart';
import 'package:zapxx/view/nav_bar/user/home/map_slide_screen/widgets/profile_section.dart';
import 'package:zapxx/view/nav_bar/user/home/services/widgets/scheduler_type_model.dart';
import 'package:zapxx/view/nav_bar/user/profile/current_user/saved_photographer/booking/booking_screen.dart';
import 'package:zapxx/view/nav_bar/user/profile/current_user/saved_photographer/posts/widgets/availble_slot_widget.dart';
import 'package:zapxx/view/nav_bar/user/profile/current_user/saved_photographer/posts/widgets/duration_selection_widget.dart';

class PostDetailsScreen extends StatefulWidget {
  const PostDetailsScreen({super.key});

  @override
  State<PostDetailsScreen> createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen>
    with SingleTickerProviderStateMixin {
  ServiceSchedulerType? _portfolioScheduler;
  TimeSlot? selectedSlot;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
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
            text: 'Posting Information',
            fontSized: 18.0,
            fontWeight: FontWeight.w600,
            color: AppColors.blackColor,
          ),
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(thickness: 1),
                  SizedBox(height: 10.h),
                  ProfileSection(
                    portfolioScheduler: _portfolioScheduler!,
                    reviewCount: 4,
                    average: '4.8',
                  ),
                  SizedBox(height: 16.w),
                  const LocationDetails(location: 'Lahore Punjab Pakistan '),
                  SizedBox(height: 16.w),
                  //  const PicturesGallery(),
                  SizedBox(height: 16.w),
                  TabBar(
                    labelColor: AppColors.backgroundColor,
                    labelStyle: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'nunito sans',
                    ),
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: AppColors.backgroundColor,
                    tabs: const [Tab(text: 'Time Slots'), Tab(text: 'Reviews')],
                  ),
                  SizedBox(
                    height: 220.w,
                    child: TabBarView(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DurationSelection(),
                            AvailableSlots(timeScheduler: _portfolioScheduler!),
                          ],
                        ),
                        Center(
                          child: CustomText(
                            text: 'Reviews Tab Content',
                            fontSized: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.w),
                  Center(
                    child: CustomButton(
                      title: 'View Details',
                      onPressed: () {},
                      btnColor: AppColors.backgroundColor,
                      btnTextColor: AppColors.whiteColor,
                    ),
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
              Positioned(
                top: 21,
                right: 31,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => BookingScreen(
                              sellerId: _portfolioScheduler!.seller.id,
                            ),
                      ),
                    );
                  },
                  child: Image(
                    width: 18.w,
                    height: 18.w,
                    color: AppColors.backgroundColor,
                    image: const AssetImage('assets/images/invite_friend.png'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
