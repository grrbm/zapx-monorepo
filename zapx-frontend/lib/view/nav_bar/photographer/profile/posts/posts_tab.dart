import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/model/post_list_model.dart' as post_list;
import 'package:zapxx/repository/home_api/home_http_api_repository.dart';
import 'package:zapxx/view_model/services/session_manager/session_controller.dart';
import 'package:zapxx/view/nav_bar/photographer/profile/posts/post_details_screen.dart';
import 'package:zapxx/configs/app_url.dart';

class PostsTab extends StatefulWidget {
  final int? sellerId;

  const PostsTab({super.key, this.sellerId});

  @override
  State<PostsTab> createState() => _PostsTabState();
}

class _PostsTabState extends State<PostsTab> {
  List<post_list.Post> _posts = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final token = SessionController().authModel.response.token;
      HomeHttpApiRepository repository = HomeHttpApiRepository();

      // Get seller ID from widget or fetch it
      int sellerId = widget.sellerId ?? await _getSellerId();

      final postModel = await repository.fetchSellerPosts(
        sellerId: sellerId,
        headers: {'Authorization': token, 'Content-Type': 'application/json'},
      );

      setState(() {
        _posts = postModel.posts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
      print('Error fetching posts: $e');
    }
  }

  Future<int> _getSellerId() async {
    try {
      final token = SessionController().authModel.response.token;
      HomeHttpApiRepository repository = HomeHttpApiRepository();
      final sellerResponse = await repository.fetchSeller({
        'Authorization': token,
        'Content-Type': 'application/json',
      });
      return sellerResponse.user.seller.id;
    } catch (e) {
      print('Error getting seller ID: $e');
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyColor.withOpacity(0.04),
      body:
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(
                  color: AppColors.backgroundColor,
                ),
              )
              : _error != null
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      text: 'Error loading posts',
                      color: AppColors.blackColor,
                      fontSized: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(height: 10.h),
                    CustomText(
                      text: _error!,
                      color: AppColors.greyColor,
                      fontSized: 14.sp,
                    ),
                    SizedBox(height: 20.h),
                    ElevatedButton(
                      onPressed: _fetchPosts,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              )
              : _posts.isEmpty
              ? Center(
                child: CustomText(
                  text: 'No posts found',
                  color: AppColors.blackColor,
                  fontSized: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              )
              : Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: SizedBox(
                  height: 305.w,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _posts.length,
                    itemBuilder: (context, index) {
                      final post = _posts[index];
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
                                  child:
                                      post.images?.isNotEmpty == true
                                          ? Image.network(
                                            '${AppUrl.baseUrl}/${post.images!.first.url}',
                                            fit: BoxFit.cover,
                                            errorBuilder: (
                                              context,
                                              error,
                                              stackTrace,
                                            ) {
                                              return const Image(
                                                fit: BoxFit.cover,
                                                image: AssetImage(
                                                  'assets/images/gallery2.png',
                                                ),
                                              );
                                            },
                                          )
                                          : const Image(
                                            fit: BoxFit.cover,
                                            image: AssetImage(
                                              'assets/images/gallery2.png',
                                            ),
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
                                          post.location?.isNotEmpty == true
                                              ? post.location!
                                              : 'Location not specified',
                                      fontSized: 14.0,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.blackColor,
                                    ),
                                    SizedBox(height: 4.h),
                                    CustomText(
                                      text:
                                          post.description?.isNotEmpty == true
                                              ? post.description!
                                              : 'No description',
                                      fontSized: 12.0,
                                      fontWeight: FontWeight.normal,
                                      color: AppColors.greyColor.withOpacity(
                                        0.5,
                                      ),
                                      maxLines: 2,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: 137.w,
                                          child: CustomText(
                                            text:
                                                'Rate: \$${post.hourlyRate ?? '0'}/hr',
                                            fontSized: 12.sp,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.blueColor,
                                            alignment: TextAlign.start,
                                          ),
                                        ),
                                        Container(
                                          width: 64.w,
                                          height: 32.w,
                                          decoration: BoxDecoration(
                                            color: AppColors.backgroundColor
                                                .withOpacity(0.04),
                                            borderRadius: BorderRadius.circular(
                                              8.r,
                                            ),
                                          ),
                                          child: Center(
                                            child: CustomText(
                                              text:
                                                  '\$${post.hourlyRate ?? '0'}',
                                              fontSized: 12.sp,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.blackColor,
                                            ),
                                          ),
                                        ),
                                      ],
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
                                              singlePost: post,
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
              ),
    );
  }
}
