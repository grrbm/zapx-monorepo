import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/view/nav_bar/photographer/home/home_screen/home_screen.dart';
import 'package:zapxx/view/nav_bar/photographer/message/message_screen.dart';
import 'package:zapxx/view/nav_bar/photographer/profile/photographer_profile_screen.dart';
import 'package:zapxx/view/nav_bar/photographer/setting/current_user_setting_screen.dart';
import 'package:zapxx/view/nav_bar/user/booking/booking_schedule_screen.dart';
import 'package:zapxx/model/user/seller_model.dart';
import 'package:zapxx/model/user/seller_review_model.dart';
import 'package:zapxx/repository/home_api/home_http_api_repository.dart';
import 'package:zapxx/view_model/services/session_manager/session_controller.dart';
import 'package:zapxx/view/nav_bar/user/profile/current_user/saved_photographer/gigs/portfolio_subtab/portfolio_model.dart'
    as portfolio_model;
import 'package:zapxx/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

class PhotographerNavBar extends StatefulWidget {
  const PhotographerNavBar({super.key});

  @override
  State<PhotographerNavBar> createState() => _PhotographerNavBarState();
}

class _PhotographerNavBarState extends State<PhotographerNavBar> {
  int counter = 0;
  int _currentIndex = 0;

  // Data variables
  UserResponse? seller;
  SellerReviewModel? sellerReview;
  portfolio_model.PortfolioResponse? portfolioResponse;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<UserViewModel>(context, listen: false).fetchSeller();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      setState(() => isLoading = true);

      // Load all data in parallel for better performance
      final results = await Future.wait([_fetchSeller(), _fetchPortfolio()]);

      final sellerData = results[0] as UserResponse;
      final portfolioData = results[1] as portfolio_model.PortfolioResponse;

      // Fetch seller reviews after we have the seller ID
      final reviewData = await _fetchSellerReview(sellerData.user.seller.id);

      setState(() {
        seller = sellerData;
        sellerReview = reviewData;
        portfolioResponse = portfolioData;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      print('Error loading profile data: $e');
    }
  }

  Future<UserResponse> _fetchSeller() async {
    try {
      HomeHttpApiRepository repository = HomeHttpApiRepository();
      final token = SessionController().authModel.response.token;

      UserResponse seller = await repository.fetchSeller({
        'Authorization': token,
      });
      return seller;
    } catch (e) {
      print('Error fetching seller: $e');
      return Future.error(e);
    }
  }

  Future<SellerReviewModel> _fetchSellerReview(int id) async {
    try {
      HomeHttpApiRepository repository = HomeHttpApiRepository();
      final token = SessionController().authModel.response.token;

      SellerReviewModel seller = await repository.fetchSellerReview({
        'Authorization': token,
      }, id);
      return seller;
    } catch (e) {
      print('Error fetching reviews: $e');
      return Future.error(e);
    }
  }

  Future<portfolio_model.PortfolioResponse> _fetchPortfolio() async {
    try {
      HomeHttpApiRepository repository = HomeHttpApiRepository();
      final token = SessionController().authModel.response.token;

      portfolio_model.PortfolioResponse gettingPortfolio = await repository
          .getPortfolio({'Authorization': token});
      return gettingPortfolio;
    } catch (e) {
      print('Error fetching portfolio: $e');
      return Future.error(e);
    }
  }

  List<Widget> get _widgetList => [
    PhotographerHomeScreen(),
    const BookingScheduleScreen(),
    PhotographerProfileScreen(
      seller: seller,
      sellerReview: sellerReview,
      portfolioResponse: portfolioResponse,
      isLoading: isLoading,
      onProfileUpdated: _loadProfileData,
    ),
    const MessagesScreen(),
    CurrentUserSettingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            unselectedIconTheme: IconThemeData(
              color: Colors.grey[400],
              size: 30,
            ),
            selectedIconTheme: const IconThemeData(
              color: AppColors.blackColor,
              size: 35,
            ),
            unselectedLabelStyle: const TextStyle(
              color: AppColors.greyColor,
              fontSize: 14,
            ),
            selectedLabelStyle: const TextStyle(
              color: AppColors.blackColor,
              fontSize: 14,
            ),
            fixedColor: AppColors.blackColor,
            type: BottomNavigationBarType.fixed,
            onTap: onTapped,
            currentIndex: _currentIndex,
            items: [
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/images/home_icon.png',
                  height: 25.h,
                  width: 25.w,
                  color:
                      _currentIndex == 0
                          ? AppColors.blackColor
                          : Colors.grey[400],
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/images/Calendar.png',
                  height: 25.h,
                  width: 25.w,
                  color:
                      _currentIndex == 1
                          ? AppColors.blackColor
                          : Colors.grey[400],
                ),
                label: 'Booking',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/images/profile.png',
                  height: 25.h,
                  width: 25.w,
                  color:
                      _currentIndex == 2
                          ? AppColors.blackColor
                          : Colors.grey[400],
                ),
                label: 'Profile',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/images/Chat.png',
                  height: 25.h,
                  width: 25.w,
                  color:
                      _currentIndex == 3
                          ? AppColors.blackColor
                          : Colors.grey[400],
                ),
                label: 'Messages',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/images/setting.png',
                  height: 25.h,
                  width: 25.w,
                  color:
                      _currentIndex == 4
                          ? AppColors.blackColor
                          : Colors.grey[400],
                ),
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
      body: _widgetList[_currentIndex],
    );
  }

  void onTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
