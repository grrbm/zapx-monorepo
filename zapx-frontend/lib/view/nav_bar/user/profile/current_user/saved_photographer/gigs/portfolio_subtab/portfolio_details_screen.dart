import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapxx/configs/app_url.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/view/nav_bar/user/profile/current_user/saved_photographer/gigs/portfolio_subtab/portfolio_model.dart';
import 'package:zapxx/view/nav_bar/user/profile/current_user/saved_photographer/gigs/portfolio_subtab/full_screen_photo_viewer.dart';

class PortfolioDetailsScreen extends StatefulWidget {
  const PortfolioDetailsScreen({super.key, required this.portfolio});
  final PortfolioSeller portfolio;
  @override
  State<PortfolioDetailsScreen> createState() => _PortfolioDetailsScreenState();
}

class _PortfolioDetailsScreenState extends State<PortfolioDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back_ios, color: AppColors.blackColor),
        ),
        title: const CustomText(
          text: 'Portfolio Detail',
          fontSized: 18.0,
          fontWeight: FontWeight.w600,
          color: AppColors.blackColor,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Divider(thickness: 1),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: CustomText(
                      text: widget.portfolio.title,
                      fontSized: 24.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.blackColor,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  SizedBox(
                    height: 500.h,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 155 / 180,
                            ),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => FullScreenPhotoViewer(
                                        images: widget.portfolio.images,
                                        initialIndex: index,
                                        portfolioTitle: widget.portfolio.title,
                                      ),
                                ),
                              );
                            },
                            child: Container(
                              height: 220.w,
                              width: 330.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                image:
                                    widget.portfolio.images[index].url.isEmpty
                                        ? const DecorationImage(
                                          image: AssetImage(
                                            'assets/images/gallery5.png',
                                          ),
                                          fit: BoxFit.cover,
                                        )
                                        : DecorationImage(
                                          image: NetworkImage(
                                            AppUrl.baseUrl +
                                                '/' +
                                                widget
                                                    .portfolio
                                                    .images[index]
                                                    .url,
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                              ),
                            ),
                          );
                        },
                        itemCount: widget.portfolio.images.length,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
