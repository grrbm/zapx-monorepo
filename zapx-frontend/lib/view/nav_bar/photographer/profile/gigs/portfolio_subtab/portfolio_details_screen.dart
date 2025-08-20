import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart'; // Import

class PortfolioDetailsScreen extends StatefulWidget {
  const PortfolioDetailsScreen({super.key});

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
          child: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.blackColor,
          ),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(
              thickness: 1,
            ),
            SizedBox(height: 26.w),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: CustomText(
                text: 'Pet Portfolio',
                fontSized: 20.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.blackColor,
                alignment: TextAlign.start,
              ),
            ),
            SizedBox(height: 20.w),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: MasonryGridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate:
                    const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two columns
                ),
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
                itemCount: 5, // Number of images
                itemBuilder: (context, index) {
                  return buildImageTile(index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildImageTile(int index) {
    // Different heights for each image for the staggered effect
    double height = index.isEven ? 200.h : 150.h;
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        image: DecorationImage(
          image: AssetImage('assets/images/gallery${index + 1}.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
