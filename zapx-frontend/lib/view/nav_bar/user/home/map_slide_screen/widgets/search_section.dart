import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/view/nav_bar/user/home/filter/filter_screen.dart';

class SearchSection extends StatelessWidget {
  const SearchSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {},
          child: Container(
            width: 345.w,
            height: 48.w,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image(
                      width: 20.w,
                      height: 20.w,
                      image: const AssetImage('assets/images/map_pin.png'),
                    ),
                    SizedBox(width: 8.w),
                    const CustomText(
                      text: 'New York, US',
                      fontSized: 14.0,
                      color: AppColors.blackColor,
                    ),
                  ],
                ),
                Row(
                  children: [
                    VerticalDivider(indent: 15.w, endIndent: 15.w),
                    SizedBox(width: 5.w),
                    const CustomText(
                      text: 'When?',
                      fontSized: 14.0,
                      color: AppColors.blackColor,
                    ),
                    SizedBox(width: 80.w),
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
                          builder: (context) => const FilterScreen(),
                        );
                      },
                      child: Image(
                        width: 18.w,
                        height: 18.w,
                        image: const AssetImage('assets/images/filter.png'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
