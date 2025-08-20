import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zapxx/configs/app_url.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_app_bar.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/configs/utils.dart';
import 'package:zapxx/model/user/seller_model.dart';
import 'package:zapxx/repository/home_api/home_http_api_repository.dart';
import 'package:zapxx/view/authentication/welcome/choose_auth_screen.dart';
import 'package:zapxx/view/nav_bar/photographer/setting/help_and_support/help_and_support_screen.dart';
import 'package:zapxx/view/nav_bar/photographer/setting/payment_method/payment_method_screen.dart';
import 'package:zapxx/view_model/services/session_manager/session_controller.dart';
import 'package:zapxx/view/nav_bar/user/message/chat/booking/all_booking/booking_details/widgets/dialog_button_widget.dart';
import 'package:http/http.dart' as http;

class CurrentUserSettingScreen extends StatefulWidget {
  const CurrentUserSettingScreen({super.key});

  @override
  State<CurrentUserSettingScreen> createState() =>
      _CurrentUserSettingScreenState();
}

class _CurrentUserSettingScreenState extends State<CurrentUserSettingScreen> {
  final SessionController _sessionController = SessionController();
  Future<Map<String, dynamic>> deleteUser() async {
    final url = Uri.parse('https://api-zapx.binarymarvels.com/auth/delete');
    final token = _sessionController.authModel.response.token;
    final response = await http.delete(
      url,
      headers: {'Authorization': token, 'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to delete user: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    void showInviteBottomSheet(BuildContext context) async {
      final result = await Share.share(
        '*Invite a Client*\nShare this link to invite a client to book\n https://zapxapp.com',
        subject: 'ZapX',
      );
      if (result.status == ShareResultStatus.success) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Invitation send!.')));
      }
    }

    void showReferBottomSheet(BuildContext context) async {
      final result = await Share.share(
        '*Refer a Photographer*\nShared this link to refer a photographer to book\n https://zapxapp.com',
        subject: 'ZapX Referal',
      );
      if (result.status == ShareResultStatus.success) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Invitation send!.')));
      }
    }

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: const CustomAppBar(title: 'Profile', leadingIcon: SizedBox()),
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
                  ProfileWidget(),
                  SizedBox(height: 30.w),
                  GestureDetector(
                    onTap: () async {
                      final Uri _url = Uri.parse('https://zapxapp.com');
                      if (!await launchUrl(_url)) {
                        throw Exception('Could not launch $_url');
                      }
                    },
                    child: const PremiumWidget(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 34.h, bottom: 10.h),
                    child: const CustomText(
                      text: 'Setting',
                      color: AppColors.greyColor,
                      fontSized: 14.0,
                      alignment: TextAlign.start,
                    ),
                  ),
                  // _buildSettingsItem(
                  //   image: 'payment',
                  //   title: 'Payment Methods',
                  //   ontap: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => const PaymentMethodScreen(),
                  //       ),
                  //     );
                  //   },
                  // ),
                  _buildSettingsItem(
                    image: 'refer_photographer',
                    title: 'Refer a Photographer',
                    ontap: () {
                      showReferBottomSheet(context);
                    },
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
                    ontap: () async {
                      final Uri _url = Uri.parse(
                        'https://zapxapp.com/privacy.html',
                      );
                      if (!await launchUrl(_url)) {
                        throw Exception('Could not launch $_url');
                      }
                    },
                    // ontap: () {

                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => const TermsOfServicesScreen(),
                    //     ),
                    //   );
                    // },
                  ),
                  // _buildSettingsItem(
                  //   image: 'privacy_policy',
                  //   title: 'Privacy policy',
                  // ),
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
                  // _buildSettingsItem(
                  //   image: 'help',
                  //   title: 'Cancellation & no show policy',
                  //   ontap: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder:
                  //             (context) =>
                  //                 const CancellationAndNoShowPolicyScreen(),
                  //       ),
                  //     );
                  //   },
                  // ),
                  _buildSettingsItem(
                    ontap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: AppColors.whiteColor,
                            title: const CustomText(
                              maxLines: 2,
                              text: 'Delete Seller',
                              fontSized: 19.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.backgroundColor,
                            ),
                            content: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.w),
                              child: const CustomText(
                                maxLines: 4,
                                text:
                                    'Are you sure you want to delete this user? This action cannot be undone, and all associated data will be permanently removed.',
                                fontSized: 14.0,
                                fontWeight: FontWeight.w700,
                                color: AppColors.redColor,
                              ),
                            ),
                            actions: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomButton(
                                    color: AppColors.whiteColor,
                                    text: 'Cancel',
                                    textColor: AppColors.redColor,
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  SizedBox(width: 16.w),
                                  CustomButton(
                                    color: AppColors.backgroundColor,
                                    text: 'Delete',
                                    textColor: AppColors.whiteColor,
                                    onTap: () {
                                      deleteUser()
                                          .then((value) {
                                            _sessionController.logout();
                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (context) =>
                                                        const ChooseAuthScreen(),
                                              ),
                                              (route) => false,
                                            );
                                          })
                                          .catchError((error) {
                                            Utils.flushBarErrorMessage(
                                              'Failed to delete user: $error',
                                              context,
                                            );
                                          });
                                      Utils.flushBarSuccessMessage(
                                        'User Deleted successfully ',
                                        context,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    },
                    image: 'delete',
                    title: 'Delete Account',
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 14.0.h),
                    child: Center(
                      child: TextButton(
                        onPressed: () async {
                          await _sessionController.logout().then((value) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ChooseAuthScreen(),
                              ),
                              (route) => false,
                            );
                          });
                        },
                        child: const CustomText(
                          text: 'Logout',
                          color: AppColors.redColor,
                          fontSized: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
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
          contentPadding: EdgeInsets.symmetric(vertical: 10),

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

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  String email = 'Loading...';
  bool isLoading = true;
  UserResponse? seller;
  late final HomeHttpApiRepository _repository;
  late final SessionController _sessionController;

  @override
  void initState() {
    super.initState();
    _repository = HomeHttpApiRepository();
    _sessionController = SessionController();
    _loadSellerData();
  }

  Future<void> _loadSellerData() async {
    try {
      final token = _sessionController.authModel.response.token;

      UserResponse sellerData = await _repository.fetchSeller({
        'Authorization': token,
      });

      if (mounted) {
        // Add a small delay to prevent flickering and make loading feel more natural
        await Future.delayed(const Duration(milliseconds: 300));
        if (mounted) {
          setState(() {
            seller = sellerData;
            isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        print('Error fetching seller data: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildLoadingSkeleton();
    }

    if (seller == null) {
      return GestureDetector(
        onTap: () {
          setState(() {
            isLoading = true;
          });
          _loadSellerData();
        },
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text: 'Failed to load profile data',
                color: AppColors.greyColor,
              ),
              SizedBox(height: 8),
              CustomText(
                text: 'Tap to retry',
                color: AppColors.backgroundColor,
                fontSized: 12,
              ),
            ],
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 56.h,
          height: 56.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image:
                seller!.user.profileImage?.url == null
                    ? const DecorationImage(
                      image: AssetImage('assets/images/profile_picture.png'),
                      fit: BoxFit.cover,
                    )
                    : DecorationImage(
                      image: NetworkImage(
                        AppUrl.baseUrl + '/' + seller!.user.profileImage!.url,
                      ),
                      fit: BoxFit.cover,
                    ),
          ),
        ),
        SizedBox(width: 12.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CustomText(
                  text: seller!.user.fullName, // Use the email variable
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
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: seller!.user.email));
                Utils.flushBarSuccessMessage(
                  'Profile link copied to clipboard!',
                  context,
                );
              },
              child: Row(
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
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLoadingSkeleton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 56.h,
          height: 56.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.greyColor.withOpacity(0.3),
          ),
        ),
        SizedBox(width: 12.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 120.w,
              height: 16.h,
              decoration: BoxDecoration(
                color: AppColors.greyColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            SizedBox(height: 8.w),
            Container(
              width: 100.w,
              height: 12.h,
              decoration: BoxDecoration(
                color: AppColors.greyColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4.r),
              ),
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
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CustomText(
                text: 'Zapx',
                fontSized: 27.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.whiteColor,
              ),
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
