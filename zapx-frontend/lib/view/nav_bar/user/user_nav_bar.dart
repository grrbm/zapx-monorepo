import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/model/user/consumer_model.dart';
import 'package:zapxx/repository/home_api/home_http_api_repository.dart';
import 'package:zapxx/view/nav_bar/photographer/message/message_screen.dart';
import 'package:zapxx/view/nav_bar/user/booking/booking_schedule_screen.dart';
import 'package:zapxx/view/nav_bar/user/home/home_screen/home_screen.dart';
import 'package:zapxx/view/nav_bar/user/profile/current_user/current_user_profile_screen.dart';
import 'package:zapxx/view/nav_bar/user/profile/current_user/saved_photographer_model.dart';
import 'package:zapxx/view_model/services/session_manager/session_controller.dart';

class UserNavBar extends StatefulWidget {
  const UserNavBar({super.key});

  @override
  State<UserNavBar> createState() => _UserNavBarState();
}

class _UserNavBarState extends State<UserNavBar> {
  int counter = 0;
  int _currentIndex = 0;
  UserConsumer? _consumer;
  SavedPhotographerModel? _savedSeller;
  final SessionController _sessionController = SessionController();

  final List<Widget> _widgetList = [];

  @override
  void initState() {
    super.initState();
    _initializeWidgets();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      UserConsumer consumerData = await _fetchUserData();
      SavedPhotographerModel savedSellerData = await _fetchSavedSeller();
      setState(() {
        _consumer = consumerData;
        _savedSeller = savedSellerData;
        _initializeWidgets(); // Re-initialize widgets with loaded data
      });
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  Future<UserConsumer> _fetchUserData() async {
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
      print('Error fetching user data: $e');
      return Future.error(e);
    }
  }

  Future<SavedPhotographerModel> _fetchSavedSeller() async {
    final token = _sessionController.authModel.response.token;
    print('Fetching saved seller data ${token}');
    if (token.isEmpty) {
      throw Exception('User not authenticated or token missing');
    }
    print('Fetching saved seller data ${token}');
    try {
      // Add headers if required
      Map<String, String> headers = {'Authorization': token};

      // Fetch data from API
      SavedPhotographerModel userData = await HomeHttpApiRepository()
          .fetchSavedSeller(headers);

      // Update provider
      return userData;
    } catch (e) {
      print('Error fetching saved seller data: $e');
      return Future.error(e);
    }
  }

  void _initializeWidgets() {
    _widgetList.clear();
    _widgetList.addAll([
      const HomeScreen(),
      const BookingScheduleScreen(),
      const MessagesScreen(),
      CurrentUserProfileScreen(consumer: _consumer, savedSeller: _savedSeller),
    ]);
  }

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
                  'assets/images/home.png',
                  height: 35.h,
                  width: 35.w,
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
                  height: 35.h,
                  width: 35.w,
                  color:
                      _currentIndex == 1
                          ? AppColors.blackColor
                          : Colors.grey[400],
                ),
                label: 'Booking',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/images/Chat.png',
                  height: 35.h,
                  width: 35.w,
                  color:
                      _currentIndex == 2
                          ? AppColors.blackColor
                          : Colors.grey[400],
                ),
                label: 'Messages',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/images/nav_Profile.png',
                  height: 35.h,
                  width: 35.w,
                  color:
                      _currentIndex == 3
                          ? AppColors.blackColor
                          : Colors.grey[400],
                ),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
      body: Center(child: _widgetList[_currentIndex]),
    );
  }

  void onTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
