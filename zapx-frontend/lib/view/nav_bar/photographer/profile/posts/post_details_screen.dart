import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_app_bar.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/configs/utils.dart';
import 'package:zapxx/controller/post_controller.dart';
import 'package:zapxx/view/nav_bar/photographer/profile/posts/people_booked_you_screen.dart';
import 'package:http/http.dart' as http;
import 'package:zapxx/view_model/services/session_manager/session_controller.dart';
import 'package:get/get.dart';

import '../../../../../model/post_list_model.dart' as post_list;

class PostDetailsScreen extends StatefulWidget {
  final post_list.Post? singlePost;
  const PostDetailsScreen({super.key, this.singlePost});

  @override
  State<PostDetailsScreen> createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen>
    with SingleTickerProviderStateMixin {
  Future<void> deletePost() async {
    if (widget.singlePost?.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Post ID is missing. Unable to delete post.'),
        ),
      );
      return;
    }
    final token = SessionController().authModel.response.token;
    final url = Uri.parse(
      'https://api-zapx.binarymarvels.com/post/${widget.singlePost!.id}',
    );
    try {
      final response = await http.delete(
        url,
        headers: {
          'Authorization': token, // Replace with your token
        },
      );

      if (response.statusCode == 200) {
        Get.find<PostController>().removePost(widget.singlePost!.id!);

        Navigator.pop(context); // Navigate back after deletion
        Utils.flushBarSuccessMessage('Post deleted successfully!', context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete post: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred while deleting post: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.whiteColor.withOpacity(0.98),
        appBar: CustomAppBar(
          title: 'Post Details',
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: GestureDetector(
                onTap: () {
                  deletePost(); // Call the deletePost function
                },
                child: Image(
                  width: 22.w,
                  height: 22.w,
                  image: const AssetImage('assets/images/delete.png'),
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Business Image and Information
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: AppColors.whiteColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 10.w,
                          horizontal: 15.w,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Image.network(
                            'https://api-zapx.binarymarvels.com/${widget.singlePost?.images?.first.url}' ??
                                '', // Ensure URL is not null
                            fit: BoxFit.cover,
                            height: 300,
                            width: MediaQuery.of(context).size.width,
                            errorBuilder:
                                (context, error, stackTrace) =>
                                    const Icon(Icons.image_not_supported),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 12.w,
                          right: 12.w,
                          bottom: 12.w,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: widget.singlePost?.notes ?? '',
                              fontSized: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.blackColor,
                            ),
                            SizedBox(height: 4.w),
                            CustomText(
                              text: widget.singlePost?.location ?? '',
                              fontSized: 12.sp,
                              color: AppColors.greyColor.withOpacity(0.5),
                            ),
                            SizedBox(height: 10.w),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomText(
                                  text: 'Hourly Booking rate ',
                                  fontSized: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.blueColor,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 4.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.backgroundColor
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: CustomText(
                                    text: widget.singlePost?.hourlyRate ?? '',
                                    fontSized: 12.sp,
                                    color: AppColors.backgroundColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),

                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: AppColors.whiteColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: MediaQuery.of(context).size.width),
                      CustomText(
                        text: 'Description',
                        fontSized: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.blackColor.withOpacity(0.7),
                      ),
                      SizedBox(height: 8.h),
                      CustomText(
                        text: widget.singlePost?.description ?? '',
                        fontSized: 14.sp,
                        color: AppColors.greyColor,
                        alignment: TextAlign.start,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: AppColors.whiteColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: 'People Who Booked You',
                        fontSized: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.blackColor.withOpacity(0.7),
                      ),
                      SizedBox(height: 8.h),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 3,
                        separatorBuilder:
                            (context, index) => SizedBox(height: 8.h),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          const PeopleBookedYouScreen(),
                                ),
                              );
                            },
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 20.r,
                                backgroundImage: const AssetImage(
                                  'assets/images/profile_picture.png',
                                ),
                              ),
                              title: CustomText(
                                text: 'User ${index + 1}',
                                fontSized: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.blackColor,
                                alignment: TextAlign.start,
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 16.w,
                                color: AppColors.greyColor,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
