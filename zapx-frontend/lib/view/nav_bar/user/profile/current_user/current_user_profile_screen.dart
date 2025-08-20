import 'dart:convert';

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_screenutil/flutter_screenutil.dart';
// ignore: depend_on_referenced_packages
import 'package:share_plus/share_plus.dart';
import 'package:zapxx/configs/app_url.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/configs/utils.dart';
import 'package:zapxx/model/user/consumer_model.dart';
import 'package:zapxx/repository/home_api/home_http_api_repository.dart';
import 'package:zapxx/view/authentication/welcome/choose_auth_screen.dart';
import 'package:zapxx/view/nav_bar/photographer/setting/help_and_support/help_and_support_screen.dart';
import 'package:zapxx/view/nav_bar/user/profile/current_user/edit_profile/edit_profile_screen.dart';
import 'package:zapxx/view/nav_bar/user/profile/current_user/saved_photographer_model.dart';
import 'package:zapxx/view/nav_bar/user/profile/current_user/saved_photographer_screen.dart';
import 'package:zapxx/view_model/services/session_manager/session_controller.dart';
import 'package:zapxx/view_model/user_view_model.dart';
import 'package:provider/provider.dart';
import 'package:zapxx/view/nav_bar/user/message/chat/booking/all_booking/booking_details/widgets/dialog_button_widget.dart';
import 'package:http/http.dart' as http;

class CurrentUserProfileScreen extends StatefulWidget {
  final UserConsumer? consumer;
  final SavedPhotographerModel? savedSeller;

  const CurrentUserProfileScreen({super.key, this.consumer, this.savedSeller});

  @override
  _CurrentUserProfileScreenState createState() =>
      _CurrentUserProfileScreenState();
}

class _CurrentUserProfileScreenState extends State<CurrentUserProfileScreen> {
  UserConsumer? consumer;
  SavedPhotographerModel? savedSeller;

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
  void initState() {
    super.initState();
    // Use passed parameters if available, otherwise fetch data
    if (widget.consumer != null && widget.savedSeller != null) {
      setState(() {
        consumer = widget.consumer;
        savedSeller = widget.savedSeller;
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        UserConsumer data = await _fetchUserData(context);
        SavedPhotographerModel data1 = await _fetchSavedSeller(context);
        setState(() {
          consumer = data;
          savedSeller = data1;
        });
      });
    }
  }

  final SessionController _sessionController = SessionController();

  Future<UserConsumer> _fetchUserData(BuildContext context) async {
    final token = _sessionController.authModel.response.token;
    print('Fetching user data ${token}');
    if (token.isEmpty) {
      throw Exception('User not authenticated or token missing');
    }
    print('Fetching user data ${token}');
    try {
      // Add headers if required
      Map<String, String> headers = {'Authorization': token};

      // Fetch data from API
      UserConsumer userData = await HomeHttpApiRepository().fetchConsumerData(
        headers,
      );

      // Update provider
      return userData;
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error fetching user data: $e')));
      return Future.error(e);
    }
  }

  Future<SavedPhotographerModel> _fetchSavedSeller(BuildContext context) async {
    final token = _sessionController.authModel.response.token;
    print('Fetching user data ${token}');
    if (token.isEmpty) {
      throw Exception('User not authenticated or token missing');
    }
    print('Fetching user data ${token}');
    try {
      // Add headers if required
      Map<String, String> headers = {'Authorization': token};

      // Fetch data from API
      SavedPhotographerModel userData = await HomeHttpApiRepository()
          .fetchSavedSeller(headers);

      // Update provider
      return userData;
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error fetching user data: $e')));
      return Future.error(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserViewModel>(context, listen: false);

    void showInviteBottomSheet(BuildContext context) async {
      final result = await Share.share(
        '*Invite a friend*\nShare this link to invite friends & Get 15 % Discount',
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
      appBar: AppBar(
        title: const CustomText(
          text: 'Profile',
          fontSized: 18.0,
          fontWeight: FontWeight.w600,
          color: AppColors.blackColor,
        ),
        centerTitle: true,
        backgroundColor: AppColors.whiteColor,
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 18),
      ),
      body:
          consumer == null || savedSeller == null
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  const Divider(thickness: 1),
                  SizedBox(height: 23.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Row(
                      children: [
                        Container(
                          width: 56.h,
                          height: 56.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image:
                                consumer!.profileImage == null
                                    ? const DecorationImage(
                                      image: AssetImage(
                                        'assets/images/profile_picture.png',
                                      ),
                                      fit: BoxFit.cover,
                                    )
                                    : DecorationImage(
                                      image: NetworkImage(
                                        AppUrl.baseUrl +
                                            '/' +
                                            consumer!.profileImage!.url,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: consumer!.fullName ?? 'No Name',
                                color: AppColors.blackColor,
                                fontSized: 18.0,
                              ),
                              SizedBox(height: 8.h),
                              CustomText(
                                text:
                                    userProvider
                                        .authModel
                                        ?.response
                                        .user
                                        .email ??
                                    'No Email',
                                color: AppColors.greyColor,
                                fontSized: 14.0,
                                fontWeight: FontWeight.normal,
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (consumer != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => EditProfileScreen(
                                        userConsumer: consumer!,
                                        email:
                                            userProvider
                                                .authModel
                                                ?.response
                                                .user
                                                .email ??
                                            '',
                                      ),
                                ),
                              );
                            }
                          },
                          child: Image(
                            width: 20.34.h,
                            height: 20.34.h,
                            image: const AssetImage(
                              'assets/images/profile_edit.png',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
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
                            image: 'saved',
                            title: 'Saved Photographers',
                            ontap: () {
                              if (savedSeller != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => SavedPhotographerScreen(
                                          services: savedSeller!,
                                        ),
                                  ),
                                );
                              }
                            },
                          ),
                          _buildSettingsItem(
                            image: 'privacy_security',
                            title: 'Security & Privacy',
                          ),
                          _buildSettingsItem(
                            image: 'invite_friend',
                            title: 'Invite Friends & Get 15% Off',
                            ontap: () {
                              showInviteBottomSheet(context);
                            },
                          ),
                          _buildSettingsItem(
                            ontap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => const HelpAndSupportScreen(),
                                ),
                              );
                            },
                            image: 'help',
                            title: 'Help and Support',
                          ),
                          _buildSettingsItem(
                            ontap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor: AppColors.whiteColor,
                                    title: const CustomText(
                                      maxLines: 2,
                                      text: 'Delete User',
                                      fontSized: 19.5,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.backgroundColor,
                                    ),
                                    content: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 15.w,
                                      ),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                  await _sessionController.logout().then((
                                    value,
                                  ) {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                                const ChooseAuthScreen(),
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
