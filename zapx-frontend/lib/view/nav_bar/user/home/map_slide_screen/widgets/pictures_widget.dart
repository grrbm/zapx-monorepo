import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapxx/configs/app_url.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/view/nav_bar/user/home/services/widgets/scheduler_type_model.dart';

class PicturesGallery extends StatelessWidget {
  const PicturesGallery({super.key, required this.portfolioScheduler});
  final ServiceSchedulerType portfolioScheduler;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'Pictures',
            fontSized: 14.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.blackColor,
          ),
          SizedBox(height: 8.h),
          SizedBox(
            height: 71.w,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount:
                  portfolioScheduler.seller.portfolio!.first.images.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7.r),
                    child: Image.network(
                      AppUrl.baseUrl +
                          "/" +
                          portfolioScheduler
                              .seller
                              .portfolio!
                              .first
                              .images[index]
                              .url,
                      width: 71.w,
                      height: 71.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
