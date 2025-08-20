import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_app_bar.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/view/nav_bar/photographer/setting/help_and_support/customer_service/customer_service_screen.dart';

class HelpAndSupportScreen extends StatefulWidget {
  const HelpAndSupportScreen({super.key});

  @override
  State<HelpAndSupportScreen> createState() => _HelpAndSupportScreenState();
}

class _HelpAndSupportScreenState extends State<HelpAndSupportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: const CustomAppBar(title: 'Help & Support'),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Divider(color: AppColors.greyColor.withOpacity(0.1)),
            HelpAndSupportWidget(
              title: 'Customer Service',
              image: 'assets/images/customer_service.png',
              ontap: () async {
                final Uri emailLaunchUri = Uri(
                  scheme: 'mailto',
                  path: 'info@bmi-tech.org',
                );
                launchUrl(emailLaunchUri);
                if (!await launchUrl(emailLaunchUri)) {
                  throw Exception('Could not launch $emailLaunchUri');
                }
              },
            ),
            HelpAndSupportWidget(
              title: 'Website',
              image: 'assets/images/website.png',
              ontap: () async {
                final Uri _url = Uri.parse('https://zapxapp.com/');
                if (!await launchUrl(_url)) {
                  throw Exception('Could not launch $_url');
                }
              },
            ),
            HelpAndSupportWidget(
              title: 'Facebook',
              image: 'assets/images/facebook.png',
              ontap: () {},
            ),
            HelpAndSupportWidget(
              title: 'X',
              image: 'assets/images/twitter.png',
              ontap: () async {
                final Uri _url = Uri.parse('https://x.com/zapxapp?s=21');
                if (!await launchUrl(_url)) {
                  throw Exception('Could not launch $_url');
                }
              },
            ),
            HelpAndSupportWidget(
              title: 'Instagram',
              image: 'assets/images/instagram.png',
              ontap: () async {
                final Uri _url = Uri.parse(
                  'https://www.instagram.com/zapxapp?igsh=MTlpdDRqNGs3b2QwMQ==',
                );
                if (!await launchUrl(_url)) {
                  throw Exception('Could not launch $_url');
                }
              },
            ),
            HelpAndSupportWidget(
              title: 'User Guides/Manual',
              image: 'assets/images/user_guide.png',
              ontap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class HelpAndSupportWidget extends StatelessWidget {
  final String title;
  final String image;
  final VoidCallback ontap;
  const HelpAndSupportWidget({
    super.key,
    required this.title,
    required this.image,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20.w),
      child: InkWell(
        onTap: ontap,
        child: Container(
          width: 327.w,
          height: 62.w,
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              width: 0.8,
              color: AppColors.greyColor.withOpacity(0.08),
            ),
          ),
          child: Row(
            children: [
              SizedBox(width: 20.w),
              Image(
                width: 21.w,
                height: 21.w,
                color: AppColors.backgroundColor,
                image: AssetImage(image),
              ),
              SizedBox(width: 20.w),
              CustomText(
                text: title,
                fontSized: 16.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.blackColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
