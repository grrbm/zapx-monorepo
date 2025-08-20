import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_button.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/configs/components/network_image_widget.dart';
import 'package:zapxx/configs/app_url.dart';
import 'package:zapxx/model/offer_model.dart';
import 'package:zapxx/view/nav_bar/user/message/chat/messages_model.dart';
import 'package:zapxx/view_model/services/session_manager/session_controller.dart';

class OfferWidget extends StatelessWidget {
  final Offer offer;
  final Function(int) onAccept;
  final Function(int) onDecline;
  final bool isLoading;
  final List<UserModel>? chatUsers;
  final bool showActions; // New parameter

  const OfferWidget({
    super.key,
    required this.offer,
    required this.onAccept,
    required this.onDecline,
    this.isLoading = false,
    this.chatUsers,
    this.showActions = true, // Default to true
  });

  String _getDisplayName() {
    final currentUser = SessionController().authModel.response.user;
    final isSeller = currentUser.role == 'SELLER';

    print('🔍 Getting display name - Current user role: $isSeller');
    print('🔍 Offer seller: ${offer.seller?.user.fullName}');
    print('🔍 Offer seller ID: ${offer.sellerId}');

    if (isSeller) {
      // Seller: show consumer name
      if (offer.consumer != null && chatUsers != null) {
        final consumerUser = chatUsers!.firstWhere(
          (user) => user.id == offer.consumer!.userId,
          orElse: () => UserModel(id: 0, fullName: 'Unknown User', role: ''),
        );
        return consumerUser.fullName ?? 'Unknown User';
      }
    } else {
      // Consumer: show seller name from offer data
      if (offer.seller != null) {
        print('✅ Using seller name from offer: ${offer.seller!.user.fullName}');
        return offer.seller!.user.fullName;
      }
    }

    print('⚠️ No seller info found, returning Unknown User');
    return 'Unknown User';
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('h:mm a, MMMM d, yyyy').format(dateTime);
  }

  String _formatTimeRange(DateTime start, DateTime end) {
    final startTime = DateFormat('h:mm a').format(start);
    final endTime = DateFormat('h:mm a').format(end);
    return '$startTime - $endTime';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.backgroundColor.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with price and createdAt
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    // Consumer profile image
                    Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.backgroundColor.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: ClipOval(
                        child: Container(
                          color: AppColors.backgroundColor.withOpacity(0.1),
                          child: Icon(
                            Icons.person,
                            size: 20.sp,
                            color: AppColors.backgroundColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    // Consumer name and offer type
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: 'Booking Offer',
                            fontSized: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.greyColor,
                          ),
                          SizedBox(height: 2.h),
                          CustomText(
                            text: _getDisplayName(),
                            fontSized: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.blackColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundColor,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: CustomText(
                      text: '\$${offer.price ?? '0'}',
                      fontSized: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.whiteColor,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  // Show createdAt time
                  CustomText(
                    text: _formatDateTime(offer.createdAt),
                    fontSized: 11.sp,
                    color: AppColors.greyColor,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // Location
          Row(
            children: [
              Icon(Icons.location_on, size: 16.sp, color: AppColors.greyColor),
              SizedBox(width: 8.w),
              Expanded(
                child: CustomText(
                  text: offer.location ?? 'Location not specified',
                  fontSized: 14.sp,
                  color: AppColors.blackColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          // Date and Time
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 16.sp,
                color: AppColors.greyColor,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: CustomText(
                  text: _formatDateTime(offer.date),
                  fontSized: 14.sp,
                  color: AppColors.blackColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          // Time Range
          Row(
            children: [
              Icon(Icons.access_time, size: 16.sp, color: AppColors.greyColor),
              SizedBox(width: 8.w),
              Expanded(
                child: CustomText(
                  text: _formatTimeRange(offer.startTime, offer.endTime),
                  fontSized: 14.sp,
                  color: AppColors.blackColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // Description
          if (offer.description?.isNotEmpty == true) ...[
            CustomText(
              text: 'Description:',
              fontSized: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.blackColor,
            ),
            SizedBox(height: 4.h),
            CustomText(
              text: offer.description ?? '',
              fontSized: 14.sp,
              color: AppColors.blackColor,
            ),
            SizedBox(height: 12.h),
          ],
          // Notes
          if (offer.notes?.isNotEmpty == true) ...[
            CustomText(
              text: 'Notes:',
              fontSized: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.blackColor,
            ),
            SizedBox(height: 4.h),
            CustomText(
              text: offer.notes ?? '',
              fontSized: 14.sp,
              color: AppColors.blackColor,
            ),
            SizedBox(height: 12.h),
          ],
          // Action Buttons (only for consumer)
          if (showActions)
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    title: 'Decline',
                    onPressed: isLoading ? () {} : () => onDecline(offer.id),
                    btnColor: Colors.red,
                    btnTextColor: AppColors.whiteColor,
                    loading: false,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: CustomButton(
                    title: 'Accept',
                    onPressed: isLoading ? () {} : () => onAccept(offer.id),
                    btnColor: AppColors.backgroundColor,
                    btnTextColor: AppColors.whiteColor,
                    loading: isLoading,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
