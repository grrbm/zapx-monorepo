import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/view/nav_bar/user/profile/current_user/saved_photographer/gigs/gigs_subtab/gig_subtab_list.dart';
import 'package:zapxx/view/nav_bar/user/profile/current_user/saved_photographer/gigs/portfolio_subtab/portfolio_subtab_list.dart';

class GigsTab extends StatefulWidget {
  const GigsTab({super.key});

  @override
  State<GigsTab> createState() => _GigsTabState();
}

class _GigsTabState extends State<GigsTab> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 21.0,
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = 0;
                    });
                  },
                  child: Container(
                    width: 167.w,
                    height: 38.h,
                    decoration: BoxDecoration(
                      color:
                          selectedIndex == 0
                              ? AppColors.backgroundColor
                              : AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(9.r),
                    ),
                    child: Center(
                      child: CustomText(
                        text: 'Gigs',
                        fontSized: 16.0,
                        fontWeight: FontWeight.w700,
                        color:
                            selectedIndex == 0
                                ? AppColors.whiteColor
                                : AppColors.blackColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 9.w),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = 1;
                    });
                  },
                  child: Container(
                    width: 167.w,
                    height: 38.h,
                    decoration: BoxDecoration(
                      color:
                          selectedIndex == 1
                              ? AppColors.backgroundColor
                              : AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(9.r),
                    ),
                    child: Center(
                      child: CustomText(
                        text: 'Portfolio',
                        fontSized: 16.0,
                        fontWeight: FontWeight.w700,
                        color:
                            selectedIndex == 1
                                ? AppColors.whiteColor
                                : AppColors.blackColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: const GigsList(), //: const PortfolioList(),
          ),
        ],
      ),
    );
  }
}
