import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_app_bar.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/view/nav_bar/user/message/chat/booking/all_booking/active_tab/active_tab_screen.dart';
import 'package:zapxx/view/nav_bar/user/message/chat/booking/all_booking/past_tab/past_tab_screen.dart';
import 'package:zapxx/view/nav_bar/user/message/chat/booking/all_booking/upcoming_tab/upcoming_tab_screen.dart';
import 'package:zapxx/view/nav_bar/user/message/chat/booking/all_booking/widgets/CustomTabWidget.dart';
import 'package:zapxx/view/nav_bar/user/booking/booking_model.dart';
import 'package:zapxx/repository/home_api/home_http_api_repository.dart';
import 'package:zapxx/view_model/services/session_manager/session_controller.dart';

class AllBookingScreen extends StatefulWidget {
  const AllBookingScreen({super.key});

  @override
  State<AllBookingScreen> createState() => _AllBookingScreenState();
}

class _AllBookingScreenState extends State<AllBookingScreen> {
  int selectedIndex = 0;
  List<Booking> _bookings = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final repository = HomeHttpApiRepository();
      final token = SessionController().authModel.response.token;
      final now = DateTime.now();
      final startDate = DateTime(now.year, now.month, 1);
      final endDate = DateTime(now.year, now.month + 1, 0);
      final response = await repository.getBookings(
        startDate: startDate,
        endDate: endDate,
        headers: {'Authorization': token},
      );
      setState(() {
        _bookings = response.bookings;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  List<Booking> get _activeBookings =>
      _bookings.where((b) => b.status == 'INPROGRESS').toList();
  List<Booking> get _upcomingBookings =>
      _bookings
          .where(
            (b) =>
                b.status == 'AWAITING_BOOKING_CONFIRMATION' ||
                b.status == 'OFFER',
          )
          .toList();
  List<Booking> get _pastBookings =>
      _bookings
          .where((b) => b.status == 'COMPLETED' || b.status == 'DECLINED')
          .toList();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: const CustomAppBar(title: 'All Booking'),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(thickness: 1.w, height: 5),
            SizedBox(height: 24.w),
            Padding(
              padding: const EdgeInsets.only(left: 24.0),
              child: Row(
                children: [
                  const CustomText(
                    text: 'shots with',
                    fontSized: 14.0,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(width: 4.w),
                  CustomText(
                    text:
                        _bookings.isNotEmpty
                            ? _bookings.first.seller.user.fullName
                            : 'No bookings',
                    fontSized: 14.0,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 21.0,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = 0;
                      });
                    },
                    child: CustomTabWidget(
                      title: 'Active',
                      selectedIndex: selectedIndex,
                      index: 0,
                    ),
                  ),
                  SizedBox(width: 9.w),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = 1;
                      });
                    },
                    child: CustomTabWidget(
                      title: 'Upcoming',
                      selectedIndex: selectedIndex,
                      index: 1,
                    ),
                  ),
                  SizedBox(width: 9.w),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = 2;
                      });
                    },
                    child: CustomTabWidget(
                      title: 'Past',
                      selectedIndex: selectedIndex,
                      index: 2,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child:
                  _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : _error != null
                      ? Center(child: Text('Error: $_error'))
                      : selectedIndex == 0
                      ? ActiveTabScreen(bookings: _activeBookings)
                      : selectedIndex == 1
                      ? UpcomingTabScreen(bookings: _upcomingBookings)
                      : PastTabScreen(bookings: _pastBookings),
            ),
          ],
        ),
      ),
    );
  }
}
