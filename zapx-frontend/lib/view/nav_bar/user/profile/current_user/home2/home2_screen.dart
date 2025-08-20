import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_app_bar.dart'; 
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/view/nav_bar/user/profile/current_user/home2/widgets/bottom_listview_stack_widget.dart';

class Home2Screen extends StatefulWidget {
  const Home2Screen({super.key});

  @override
  State<Home2Screen> createState() => _Home2ScreenState();
}

class _Home2ScreenState extends State<Home2Screen> {
  List<String> filterList = ['All', 'Restaurants', 'Parks', 'Concerts'];
  int selectedFilterIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: const CustomAppBar(title: 'Discover Screen'),
      body: Stack(
        children: [
          // Full-screen background image
          Image(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
            image: const AssetImage('assets/images/map.png'),
          ),

          Padding(
            padding: EdgeInsets.only(left: 16.w, top: 14.w),
            child: SizedBox(
              height: 50.w,
              child: ListView.builder(
                itemCount: filterList.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedFilterIndex = index;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 12.w),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 11.w, horizontal: 16.w),
                        decoration: BoxDecoration(
                          color: selectedFilterIndex == index
                              ? AppColors.backgroundColor
                              : AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          children: [
                            index == 0
                                ? Padding(
                                    padding: EdgeInsets.only(right: 4.0.w),
                                    child: Image(
                                        width: 10.w,
                                        height: 13.w,
                                        color: selectedFilterIndex == index
                                            ? AppColors.whiteColor
                                            : AppColors.blackColor,
                                        image: const AssetImage(
                                            'assets/images/all_filter.png')),
                                  )
                                : const SizedBox(),
                            CustomText(
                              text: filterList[index],
                              fontSized: 12.0,
                              color: selectedFilterIndex == index
                                  ? AppColors.whiteColor
                                  : AppColors.blackColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const BottomListviewStack(),
        ],
      ),
    );
  }
}
