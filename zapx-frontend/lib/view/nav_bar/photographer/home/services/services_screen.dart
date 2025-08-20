import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_app_bar.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/view/nav_bar/user/home/services/widgets/filter_screen.dart';
import 'package:zapxx/view/nav_bar/user/home/services/widgets/photography_listview_widget.dart';
import 'package:zapxx/view/nav_bar/user/home/services/widgets/search_widget.dart';
import 'package:zapxx/view/nav_bar/user/home/services/widgets/videography_listview_widget.dart';

class ServicesScreen extends StatefulWidget {
  final String title;
  const ServicesScreen({super.key, required this.title});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(title: widget.title),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 14.w),
              child: const SearchWidget(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.w),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CustomText(
                            text:
                                widget.title == 'Photography'
                                    ? 'Photographer'
                                    : 'Videographer',
                            fontSized: 16.0,
                            fontWeight: FontWeight.w700,
                            color: AppColors.blackColor,
                          ),
                          SizedBox(width: 4.w),
                          PopupMenuButton(
                            color: AppColors.whiteColor,
                            icon: Image.asset(
                              'assets/images/arrow_down.png',
                              width: 18.w,
                              height: 18.w,
                            ),
                            onSelected: (value) {
                              print(value);
                            },
                            itemBuilder:
                                (context) => [
                                  PopupMenuItem(
                                    value: 'Videographers',
                                    child: Center(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.backgroundColor,
                                          borderRadius: BorderRadius.circular(
                                            7.r,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8.w,
                                            vertical: 6.w,
                                          ),
                                          child: CustomText(
                                            text: 'Videographers',
                                            fontSized: 16.w,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.whiteColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 'Photographers',
                                    child: Center(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.backgroundColor,
                                          borderRadius: BorderRadius.circular(
                                            7.r,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8.w,
                                            vertical: 6.w,
                                          ),
                                          child: CustomText(
                                            text: 'Photographers',
                                            fontSized: 16.w,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.whiteColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20.r),
                              ),
                            ),
                            builder:
                                (context) => ServicesFilterScreen(
                                  currentCategory: widget.title,
                                ),
                          );
                        },
                        child: Container(
                          width: 42.w,
                          height: 42.w,
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: AppColors.greyColor.withOpacity(0.4),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(12.w),
                            child: Image(
                              color: AppColors.greyColor.withOpacity(0.6),
                              image: const AssetImage(
                                'assets/images/filter.png',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14.w),
                  /*  widget.title == 'Photography'
                      ? const PhotographyListview(
                        name: 'Erico Movement',
                        image: 'assets/images/gallery3.png',
                        rating: '4.8',
                        reviews: '87',
                      )
                      : const VideographyListviewWidget(
                        name: 'Erico Movement',
                        image: 'assets/images/gallery4.png',
                        rating: '4.8',
                        reviews: '87',
                      ),*/
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
