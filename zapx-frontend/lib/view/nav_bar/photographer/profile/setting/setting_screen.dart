import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';

import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_app_bar.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/view/nav_bar/photographer/setting/cancellation/cancellation_and_no_show_policy_screen.dart';
import 'package:zapxx/view/nav_bar/photographer/setting/help_and_support/help_and_support_screen.dart';
import 'package:zapxx/view/nav_bar/photographer/setting/payment_method/payment_method_screen.dart';
import 'package:zapxx/view/nav_bar/photographer/setting/terms_of_services/terms_of_services_screen.dart';

class ProfileSettingScreen extends StatelessWidget {
  const ProfileSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void showInviteBottomSheet(BuildContext context) async {
      final result = await Share.share(
        '*Invite a Client*\nShare this link to invite a client to book',
        subject: 'ZapX',
      );
      if (result.status == ShareResultStatus.success) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Invitation send!.')));
      }
    }

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(
        title: 'Setting',
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Image(
              width: 24.w,
              height: 24.w,
              image: const AssetImage('assets/images/share.png'),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(thickness: 1),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: ListView(
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.zero,
                children: [
                  SizedBox(height: 23.h),
                  Padding(
                    padding: EdgeInsets.only(top: 34.h, bottom: 10.h),
                    child: const CustomText(
                      text: 'Setting',
                      color: AppColors.greyColor,
                      fontSized: 14.0,
                      alignment: TextAlign.start,
                    ),
                  ),
                  _buildSettingsItem(
                    image: 'payment',
                    title: 'Payment Methodss',
                    ontap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PaymentMethodScreen(),
                        ),
                      );
                    },
                  ),
                  _buildSettingsItem(
                    image: 'refer_photographer',
                    title: 'Refer a Photographer',
                  ),
                  _buildSettingsItem(
                    image: 'invite_client',
                    title: 'Invite a client',
                    ontap: () {
                      showInviteBottomSheet(context);
                    },
                  ),
                  _buildSettingsItem(
                    image: 'terms',
                    title: 'Terms of service',
                    ontap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TermsOfServicesScreen(),
                        ),
                      );
                    },
                  ),
                  _buildSettingsItem(
                    image: 'privacy_policy',
                    title: 'Privacy policy',
                  ),
                  _buildSettingsItem(
                    image: 'support_help',
                    title: 'Help and Support',
                    ontap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HelpAndSupportScreen(),
                        ),
                      );
                    },
                  ),
                  _buildSettingsItem(
                    image: 'help',
                    title: 'Cancellation & no show policy',
                    ontap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  const CancellationAndNoShowPolicyScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required String image,
    required String title,
    VoidCallback? ontap,
  }) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Image(
            width: 20.34.h,
            height: 20.34.h,
            image: AssetImage('assets/images/$image.png'),
          ),
          // dense: true,
          title: CustomText(
            text: title,
            color: AppColors.blackColor,
            fontSized: 16.sp,
            alignment: TextAlign.start,
          ),
          onTap: ontap ?? () {},
        ),
        Divider(
          indent: 36,
          thickness: 1,
          height: 0,
          color: AppColors.greyColor.withOpacity(0.1),
        ),
      ],
    );
  }
}

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 56.w,
          height: 56.w,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
          child: const Image(
            image: AssetImage('assets/images/profile_picture.png'),
          ),
        ),
        SizedBox(width: 12.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const CustomText(
                  text: 'User Profile',
                  color: AppColors.blackColor,
                  fontWeight: FontWeight.w700,
                ),
                Image(
                  width: 20.w,
                  height: 20.w,
                  image: const AssetImage('assets/images/verify.png'),
                ),
              ],
            ),
            SizedBox(height: 8.w),
            Row(
              children: [
                CustomText(
                  text: 'copyprofilelinkfromhere',
                  color: AppColors.greyColor,
                  fontSized: 14.sp,
                ),
                SizedBox(width: 4.w),
                Image(
                  width: 16.w,
                  height: 16.w,
                  image: const AssetImage('assets/images/copy.png'),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class PremiumWidget extends StatelessWidget {
  const PremiumWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 327.w,
      height: 98.w,
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomText(
                    text: 'Zap',
                    fontSized: 27.sp,
                    fontStyle: FontStyle.italic,
                    color: AppColors.whiteColor,
                  ),
                  SizedBox(width: 6.w),
                  CustomText(
                    text: 'Premium',
                    fontSized: 27.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.whiteColor,
                  ),
                ],
              ),
              CustomText(
                text: 'Trial ends 10/12/2024',
                fontSized: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.whiteColor,
              ),
              SizedBox(height: 4.w),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(100.r),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 5.w,
                  ),
                  child: CustomText(
                    text: 'Learn More',
                    fontSized: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.backgroundColor,
                  ),
                ),
              ),
            ],
          ),
          Image(
            width: 98.w,
            height: 98.w,
            fit: BoxFit.cover,
            image: const AssetImage('assets/images/photographer.png'),
          ),
        ],
      ),
    );
  }
}
