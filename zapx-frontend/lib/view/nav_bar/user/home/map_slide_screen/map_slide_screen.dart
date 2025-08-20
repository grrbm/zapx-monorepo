import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/view/nav_bar/user/home/map_slide_screen/widgets/location_details_widget.dart';
import 'package:zapxx/view/nav_bar/user/home/map_slide_screen/widgets/profile_section.dart';
import 'package:zapxx/view/nav_bar/user/home/map_slide_screen/widgets/tabs_section.dart';
import 'package:zapxx/view/nav_bar/user/home/services/widgets/scheduler_type_model.dart';
import 'widgets/pictures_widget.dart';

class MapSlideScreen extends StatefulWidget {
  const MapSlideScreen({
    super.key,
    required this.portfolioScheduler,
    required this.timeSlotScheduler,
    required this.reviewScheduler,
  });
  final ServiceSchedulerType portfolioScheduler;
  final ServiceSchedulerType timeSlotScheduler;
  final ServiceSchedulerType reviewScheduler;
  @override
  State<MapSlideScreen> createState() => _MapSlideScreenState();
}

class _MapSlideScreenState extends State<MapSlideScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        padding: EdgeInsets.symmetric(vertical: 16.w),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.w, horizontal: 24.w),
          child: Column(
            children: [
              ProfileSection(
                portfolioScheduler: widget.portfolioScheduler,
                reviewCount: widget.reviewScheduler.seller.reviewCount ?? 0,
                average: widget.reviewScheduler.avgRating.toString(),
              ),
              SizedBox(height: 16.w),
              LocationDetails(
                location: widget.portfolioScheduler.seller.location,
              ),
              SizedBox(height: 16.w),
              PicturesGallery(portfolioScheduler: widget.portfolioScheduler),
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
              Expanded(
                child: TabSection(
                  timeScheduler: widget.timeSlotScheduler,
                  review: widget.reviewScheduler,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
