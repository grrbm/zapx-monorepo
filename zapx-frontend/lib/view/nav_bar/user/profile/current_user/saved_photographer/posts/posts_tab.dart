import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/controller/post_controller.dart';
import 'package:zapxx/view/nav_bar/photographer/profile/posts/post_details_screen.dart';

class PostsTab extends StatelessWidget {
  const PostsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyColor.withOpacity(0.04),
      body: GetBuilder<PostController>(
        builder: (PostController postCtrl) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: SizedBox(
              height: 305.w,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: postCtrl.postListModel?.posts.length ?? 0,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Container(
                      width: 240.w,
                      height: 320.w,
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 5,
                            spreadRadius: 2,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 216.w,
                            height: 140.w,
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16.r),
                              child: Image.network(
                                'https://api-zapx.binarymarvels.com/${postCtrl.postListModel?.posts[index].images?.first.url}' ??
                                    '', // Ensure URL is not null
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) =>
                                        const Icon(Icons.image_not_supported),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 19.w,
                              vertical: 4.h,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text:
                                      '${postCtrl.postListModel?.posts[index].location}',
                                  fontSized: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.blackColor,
                                ),
                                SizedBox(height: 4.h),
                                CustomText(
                                  text:
                                      '${postCtrl.postListModel?.posts[index].description}',
                                  fontSized: 12.0,
                                  fontWeight: FontWeight.normal,
                                  color: AppColors.greyColor.withOpacity(0.5),
                                ),
                                CustomText(
                                  text:
                                      '${postCtrl.postListModel?.posts[index].notes}',
                                  fontSized: 12.0,
                                  fontWeight: FontWeight.normal,
                                  color: AppColors.greyColor.withOpacity(0.5),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    width: 86.w,
                                    height: 32.w,
                                    decoration: BoxDecoration(
                                      color: AppColors.backgroundColor
                                          .withOpacity(0.04),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Center(
                                      child: CustomText(
                                        text:
                                            '\$${postCtrl.postListModel?.posts[index].hourlyRate}/60 min',
                                        fontSized: 12.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.blackColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 19.w,
                              vertical: 4.w,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => PostDetailsScreen(
                                          singlePost:
                                              postCtrl
                                                  .postListModel
                                                  ?.posts[index],
                                        ),
                                  ),
                                );
                              },
                              child: Container(
                                width: 208.w,
                                height: 48.w,
                                decoration: BoxDecoration(
                                  color: AppColors.whiteColor,
                                  border: Border.all(
                                    color: AppColors.blackColor,
                                    width: 1.w,
                                  ),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Center(
                                  child: CustomText(
                                    text: 'View',
                                    fontSized: 12.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.blackColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
