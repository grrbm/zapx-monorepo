import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapxx/configs/app_url.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/repository/home_api/home_http_api_repository.dart';
import 'package:zapxx/view/nav_bar/user/profile/current_user/saved_photographer_model.dart';
import 'package:zapxx/view_model/services/session_manager/session_controller.dart';

class SavedPhotographerScreen extends StatefulWidget {
  final SavedPhotographerModel services;

  const SavedPhotographerScreen({super.key, required this.services});

  @override
  State<SavedPhotographerScreen> createState() =>
      _SavedPhotographerScreenState();
}

class _SavedPhotographerScreenState extends State<SavedPhotographerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        title: const CustomText(
          text: 'Saved Photographers',
          fontSized: 18.0,
          fontWeight: FontWeight.w600,
          color: AppColors.blackColor,
        ),
        centerTitle: true,
        backgroundColor: AppColors.whiteColor,
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 18),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView.builder(
          itemCount: widget.services.savedUser!.length,
          scrollDirection: Axis.vertical,
          physics: const ScrollPhysics(parent: NeverScrollableScrollPhysics()),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final service = widget.services.savedUser![index];
            return GestureDetector(
              onTap: () {},
              child: Container(
                width: 327.w,
                height: 135.w,
                margin: EdgeInsets.only(bottom: 10.w),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  border: Border.all(
                    color: AppColors.greyColor.withOpacity(0.1),
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(14.w),
                      child: Container(
                        width: 84.w,
                        height: 84.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40.r),
                          child: Image(
                            width: 84.w,
                            height: 84.w,
                            fit: BoxFit.cover,
                            image:
                                service.seller!.user!.profileImage != null
                                    ? NetworkImage(
                                      AppUrl.baseUrl +
                                          '/' +
                                          service
                                              .seller!
                                              .user!
                                              .profileImage!
                                              .url,
                                    )
                                    : const AssetImage(
                                          'assets/images/gallery3.png',
                                        )
                                        as ImageProvider,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 28.w),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              text: service.seller!.user!.fullName!,
                              fontSized: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.blackColor,
                            ),
                            SizedBox(width: 4.w),
                            Image(
                              width: 19.h,
                              height: 19.h,
                              image: const AssetImage(
                                'assets/images/verify.png',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 14.w),
                        CustomText(
                          text: service.seller!.aboutMe ?? 'About me ',
                          // Replace with actual reviews count from API if available
                          fontSized: 12.0,
                          fontWeight: FontWeight.w700,
                          color: AppColors.greyColor.withOpacity(0.5),
                        ),
                        SizedBox(height: 14.w),
                      ],
                    ),
                    const Spacer(),
                    Padding(
                      padding: EdgeInsets.only(right: 23.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image(
                            height: 31.w,
                            width: 31.w,
                            color: AppColors.backgroundColor,
                            image: const AssetImage(
                              'assets/images/invite_friend.png',
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              widget.services.savedUser!.removeAt(index);
                              setState(() {});
                              try {
                                final repository = HomeHttpApiRepository();
                                final token =
                                    SessionController()
                                        .authModel
                                        .response
                                        .token;

                                await repository.toggleSellerLike(
                                  sellerId: service.seller!.id!,
                                  isSaved: false,
                                  headers: {
                                    'Authorization': token,
                                    'Content-Type': 'application/json',
                                  },
                                );
                              } catch (e) {
                                // Revert state on error
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Failed to ${'unlike'} seller',
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Image(
                              height: 31.w,
                              width: 31.w,
                              image: const AssetImage(
                                'assets/images/heart.png',
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
          },
        ),
      ),
    );
  }
}
