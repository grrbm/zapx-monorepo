import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapxx/configs/app_url.dart';
import 'package:zapxx/view/nav_bar/user/profile/current_user/saved_photographer/gigs/portfolio_subtab/portfolio_model.dart'
    as portfolio_model;
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_app_bar.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/model/user/seller_model.dart';
import 'package:zapxx/model/user/seller_review_model.dart';
import 'package:zapxx/view/nav_bar/photographer/profile/setting/edit_seller.dart';
import 'package:zapxx/view/nav_bar/user/profile/current_user/saved_photographer/gigs/portfolio_subtab/portfolio_subtab_list.dart';
import 'package:zapxx/view/nav_bar/photographer/profile/posts/posts_tab.dart';
import 'package:zapxx/view/nav_bar/user/profile/current_user/saved_photographer/reviews/review_seller.dart';

class PhotographerProfileScreen extends StatefulWidget {
  final UserResponse? seller;
  final SellerReviewModel? sellerReview;
  final portfolio_model.PortfolioResponse? portfolioResponse;
  final bool isLoading;
  final VoidCallback? onProfileUpdated;

  const PhotographerProfileScreen({
    super.key,
    this.seller,
    this.sellerReview,
    this.portfolioResponse,
    this.isLoading = false,
    this.onProfileUpdated,
  });

  @override
  State<PhotographerProfileScreen> createState() =>
      _PhotographerProfileScreenState();
}

class _PhotographerProfileScreenState extends State<PhotographerProfileScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child:
          widget.isLoading || widget.seller == null
              ? const Center(
                child: CircularProgressIndicator(
                  color: AppColors.backgroundColor,
                ),
              )
              : Scaffold(
                backgroundColor: AppColors.whiteColor,
                appBar: CustomAppBar(
                  title: 'Profile',
                  leadingIcon: const SizedBox(),
                  actions: [
                    Padding(
                      padding: EdgeInsets.only(right: 16.w),
                      child: GestureDetector(
                        onTap: () async {
                          final updated = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => EditSellerProfileScreen(
                                    seller: widget.seller!.user.seller,
                                  ),
                            ),
                          );
                          if (updated == true &&
                              widget.onProfileUpdated != null) {
                            widget.onProfileUpdated!();
                          }
                        },
                        child: Image(
                          width: 20.34.h,
                          height: 20.34.h,
                          image: const AssetImage(
                            'assets/images/profile_edit.png',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Divider(thickness: 1),
                      SizedBox(height: 5.h),
                      Center(
                        child: Container(
                          width: 80.h,
                          height: 80.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image:
                                widget.seller!.user.profileImage == null
                                    ? const DecorationImage(
                                      image: AssetImage(
                                        'assets/images/profile_picture.png',
                                      ),
                                      fit: BoxFit.cover,
                                    )
                                    : DecorationImage(
                                      image: NetworkImage(
                                        '${AppUrl.baseUrl}/${widget.seller!.user.profileImage!.url}',
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                          ),
                        ),
                      ),
                      SizedBox(height: 7.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(
                            text: widget.seller!.user.fullName,
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
                      CustomText(
                        text: '@${widget.seller!.user.username}',
                        fontSized: 14.sp,
                        fontWeight: FontWeight.normal,
                        color: AppColors.greyColor.withOpacity(0.5),
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            height: 16.w,
                            width: 16.w,
                            image: const AssetImage('assets/images/star.png'),
                          ),
                          SizedBox(width: 5.h),
                          CustomText(
                            text:
                                widget.seller!.user.avgRating == null
                                    ? '0.0'
                                    : widget.seller!.user.avgRating.toString(),
                            fontSized: 12.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.blackColor,
                          ),
                          SizedBox(width: 2.h),
                          CustomText(
                            text: '(${widget.seller!.user.seller.reviewCount})',
                            fontSized: 12.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.greyColor.withOpacity(0.5),
                          ),
                        ],
                      ),
                      SizedBox(height: 6.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 41.0),
                        child: CustomText(
                          maxLines: 3,
                          text: widget.seller!.user.seller.aboutMe ?? '',
                          fontSized: 13.0,
                          color: AppColors.blackColor,
                        ),
                      ),
                      SizedBox(height: 17.h),
                      const TabBar(
                        labelColor: AppColors.blackColor,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: AppColors.backgroundColor,
                        tabs: [
                          Tab(text: 'Reviews'),
                          Tab(text: 'Portfolio'),
                          Tab(text: 'Posts'),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.81,
                        child: TabBarView(
                          children: [
                            widget.sellerReview != null
                                ? ReviewsTabSeller(
                                  paddingLeft: 24.0,
                                  sellerReview: widget.sellerReview!,
                                )
                                : const Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.backgroundColor,
                                  ),
                                ),
                            widget.portfolioResponse != null
                                ? PortfolioList(
                                  portfolioResponse: widget.portfolioResponse!,
                                )
                                : const Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.backgroundColor,
                                  ),
                                ),
                            PostsTab(sellerId: widget.seller?.user.seller.id),
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
