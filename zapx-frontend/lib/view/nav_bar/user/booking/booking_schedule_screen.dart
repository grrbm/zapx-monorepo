import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timetable_view/timetable_view.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/repository/home_api/home_http_api_repository.dart';
import 'package:zapxx/view/nav_bar/photographer/booking/add_booking/add_booking_external_screen.dart';
import 'package:zapxx/view/nav_bar/user/booking/booking_model.dart';
import 'package:zapxx/view/nav_bar/user/booking/widgets/booking_reminder_dialog.dart';
import 'package:intl/intl.dart';
import 'package:zapxx/view_model/services/session_manager/session_controller.dart';

class BookingScheduleScreen extends StatefulWidget {
  const BookingScheduleScreen({super.key});
  @override
  State<BookingScheduleScreen> createState() => _BookingScheduleScreenState();
}

class _BookingScheduleScreenState extends State<BookingScheduleScreen> {
  DateTime? _selectedDate;
  List<Booking> _bookings = [];
  bool _isLoading = true;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String _selectedView = "BY MONTH"; // For dropdown
  DateTime get _firstDayOfMonth =>
      DateTime(_focusedDay.year, _focusedDay.month, 1);
  DateTime get _lastDayOfMonth =>
      DateTime(_focusedDay.year, _focusedDay.month + 1, 0);
  int get _daysInMonth => _lastDayOfMonth.day;

  String _getMonthName(int month) {
    List<String> monthNames = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    return monthNames[month - 1];
  }

  bool _isSameDay(DateTime a, DateTime b) {
    bool result = a.year == b.year && a.month == b.month && a.day == b.day;
    print('🔄 Comparing dates: $a vs $b = $result');
    return result;
  }

  DateTime _startOfWeek(DateTime date) {
    return date.subtract(
      Duration(days: date.weekday - 1),
    ); // Week starts on Monday
  }

  DateTime _endOfWeek(DateTime date) {
    return _startOfWeek(date).add(const Duration(days: 6));
  }

  List<Booking> _filterBookings() {
    final targetDate = _selectedDay ?? _focusedDay; // Use selected/focused date

    if (_selectedView == 'BY DAY') {
      return _bookings
          .where((booking) => _isSameDay(booking.startTime, targetDate))
          .toList();
    } else if (_selectedView == 'BY WEEK') {
      final weekStart = _startOfWeek(targetDate);
      final weekEnd = _endOfWeek(targetDate).add(const Duration(days: 1));
      return _bookings
          .where(
            (b) =>
                b.startTime.isAfter(weekStart) && b.startTime.isBefore(weekEnd),
          )
          .toList();
    } else {
      // BY MONTH
      return _bookings
          .where(
            (b) =>
                b.startTime.month == _focusedDay.month &&
                b.startTime.year == _focusedDay.year,
          )
          .toList();
    }
  }

  List<Booking> _filterBookingsForSelectedDay() {
    final targetDate = _selectedDay ?? _focusedDay;
    print('🔍 Filtering bookings for target date: $targetDate');
    print('📅 Total bookings available: ${_bookings.length}');

    final filteredBookings =
        _bookings.where((booking) {
          // Use the original date field from API response for date comparison
          DateTime bookingDate = booking.date.toLocal();
          bool isSameDay = _isSameDay(bookingDate, targetDate);
          print(
            '📋 Booking ${booking.id}: date=${booking.date}, localDate=$bookingDate, isSameDay=$isSameDay',
          );
          return isSameDay;
        }).toList();

    print('✅ Filtered bookings count: ${filteredBookings.length}');
    return filteredBookings;
  }

  Future<void> _fetchBookings() async {
    try {
      final repository = HomeHttpApiRepository();
      final token = SessionController().authModel.response.token;
      final response = await repository.getBookings(
        startDate: _firstDayOfMonth,
        endDate: _lastDayOfMonth,
        headers: {'Authorization': token},
      );

      setState(() {
        _bookings = response.bookings;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load bookings: $e')));
      print('Error fetching bookings: $e');
    }
  }

  Set<DateTime> _getBookedDates() {
    return _bookings
        .map(
          (booking) => DateTime(
            booking.startTime.year,
            booking.startTime.month,
            booking.startTime.day,
          ),
        )
        .toSet();
  }

  @override
  void initState() {
    super.initState();
    _fetchBookings();
    _selectedDay = DateTime.now();
    _selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        automaticallyImplyLeading: false,
        title: CustomText(
          text: 'Bookings',
          fontSized: 20.sp, // Responsive font size
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
        centerTitle: true,
        // actions: [
        //   SessionController().authModel.response.user.role == 'SELLER'
        //       ? IconButton(
        //         onPressed: () {
        //           Navigator.push(
        //             context,
        //             MaterialPageRoute(
        //               builder:
        //                   (context) => OutStandingTabScreen(context: context),
        //             ),
        //           );
        //         },
        //         icon: Icon(Icons.reorder, color: AppColors.blackColor),
        //       )
        //       : SizedBox.shrink(),
        // ],
      ),
      floatingActionButton:
          SessionController().authModel.response.user.role == 'SELLER'
              ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 144.w, // Responsive width
                    height: 35.h, // Responsive height
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100.r),
                      border: Border.all(
                        color: const Color(0xFF48A5AF),
                        width: 1.w,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Add Booking Manually',
                        style: TextStyle(
                          fontSize: 10.sp, // Responsive font size
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF48A5AF),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5.w), // Responsive spacing
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => const AddBookingExternalScreen(),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(
                          0xFF48A5AF,
                        ), // Teal color for the add button
                        borderRadius: BorderRadius.circular(100.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(14.w), // Responsive padding
                        child: Icon(Icons.add, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              )
              : const SizedBox(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios, size: 16.sp),
                    onPressed: () {
                      setState(() {
                        if (_selectedView == 'BY MONTH') {
                          _focusedDay = DateTime(
                            _focusedDay.year,
                            _focusedDay.month - 1,
                          );
                        } else {
                          _selectedDay = _selectedDay?.subtract(
                            _selectedView == 'BY WEEK'
                                ? const Duration(days: 7)
                                : const Duration(days: 1),
                          );
                        }
                        _isLoading = true;
                      });
                      _fetchBookings();
                    },
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (_selectedView == 'BY MONTH') ...[
                        CustomText(
                          text: _getMonthName(_focusedDay.month),
                          fontSized: 16.sp, // Responsive font size
                          fontWeight: FontWeight.w700,
                          color: AppColors.blackColor,
                        ),
                        CustomText(
                          text: _focusedDay.year.toString(),
                          fontSized: 14.sp, // Responsive font size
                          fontWeight: FontWeight.w700,
                          color: AppColors.blackColor.withOpacity(0.7),
                        ),
                      ] else ...[
                        CustomText(
                          text: DateFormat(
                            'MMM yyyy',
                          ).format(_selectedDay ?? DateTime.now()),
                          fontSized: 16.sp, // Responsive font size
                          fontWeight: FontWeight.w700,
                          color: AppColors.blackColor,
                        ),
                      ],
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios, size: 16.sp),
                    onPressed: () {
                      setState(() {
                        if (_selectedView == 'BY MONTH') {
                          _focusedDay = DateTime(
                            _focusedDay.year,
                            _focusedDay.month + 1,
                          );
                        } else {
                          _selectedDay = _selectedDay?.add(
                            _selectedView == 'BY WEEK'
                                ? const Duration(days: 7)
                                : const Duration(days: 1),
                          );
                        }
                        _isLoading = true;
                      });
                      _fetchBookings();
                    },
                  ),
                ],
              ),
            ),

            // Day selection row (horizontal list view)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: SizedBox(
                height: 80.h, // Responsive height
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _selectedView == 'BY MONTH' ? _daysInMonth : 7,
                  itemBuilder: (context, index) {
                    final bookedDates = _getBookedDates();

                    // Get the correct date based on view
                    final date =
                        _selectedView == 'BY MONTH'
                            ? _firstDayOfMonth.add(Duration(days: index))
                            : _startOfWeek(
                              _selectedDay!,
                            ).add(Duration(days: index));

                    final isBooked = bookedDates.any(
                      (bookedDate) =>
                          bookedDate.year == date.year &&
                          bookedDate.month == date.month &&
                          bookedDate.day == date.day,
                    );
                    final day =
                        _selectedView == 'BY MONTH'
                            ? _firstDayOfMonth.add(Duration(days: index))
                            : _startOfWeek(
                              _selectedDay ?? DateTime.now(),
                            ).add(Duration(days: index));
                    final isCurrentMonth = day.month == _focusedDay.month;
                    final isSelected =
                        _selectedDay != null && _isSameDay(day, _selectedDay!);
                    return Opacity(
                      opacity: isCurrentMonth ? 1.0 : 0.5,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedDay = day;
                            _selectedDate = date;
                          });
                          _fetchBookings();
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: Container(
                            width: 42.w, // Responsive width
                            height: 67.h, // Responsive height
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              color:
                                  isBooked
                                      ? Colors.blue
                                      : isSelected
                                      ? Colors.teal
                                      : AppColors.greyColor.withOpacity(0.1),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  DateFormat.E().format(day),
                                  style: TextStyle(
                                    fontSize: 12.sp, // Responsive font size
                                    fontWeight: FontWeight.w600,
                                    color:
                                        isSelected
                                            ? Colors.white
                                            : AppColors.greyColor.withOpacity(
                                              0.4,
                                            ),
                                  ),
                                ),
                                SizedBox(height: 4.h), // Responsive spacing
                                Container(
                                  padding: EdgeInsets.all(
                                    8.w,
                                  ), // Responsive padding
                                  decoration: const BoxDecoration(
                                    color: AppColors.whiteColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    "${day.day}",
                                    style: TextStyle(
                                      fontSize: 14.sp, // Responsive font size
                                      fontWeight: FontWeight.w700,
                                      color:
                                          isSelected
                                              ? AppColors.backgroundColor
                                              : AppColors.greyColor.withOpacity(
                                                0.4,
                                              ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Dropdown for schedule view
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: "Booking Schedule",
                    fontSized: 16.sp, // Responsive font size
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackColor,
                  ),
                ],
              ),
            ),

            // Timetable view for the booking schedule
            Expanded(
              child: TimetableView(
                laneEventsList: _buildLaneEvents(),
                onEmptySlotTap: (int, start, end) {
                  print("Empty Slot tapped from $start to $end");
                },
                onEventTap: (event) {
                  try {
                    final booking = _bookings.firstWhere(
                      (b) => b.id == event.eventId,
                    );

                    showDialog(
                      context: context,
                      builder:
                          (context) =>
                              PhotoshootReminderDialog(booking: booking),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Booking details not found')),
                    );
                  }
                },
                timetableStyle: TimetableStyle(
                  showTimeAsAMPM: true,
                  startHour: 0, // Start at midnight
                  endHour: 24, // End at midnight
                  timeItemWidth: 40.w, // Responsive width
                  laneWidth: 100.w, // Responsive width
                  timeItemHeight: 60.h, // Responsive height
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Creating lane events with proper timezone conversion
  List<LaneEvents> _buildLaneEvents() {
    if (_isLoading) return [];
    final filteredBookings = _filterBookingsForSelectedDay();

    // Create 3 lanes for 3 columns (no visible names)
    List<LaneEvents> lanes = [
      LaneEvents(lane: Lane(name: "", laneIndex: 0), events: []),
      LaneEvents(lane: Lane(name: "", laneIndex: 1), events: []),
      LaneEvents(lane: Lane(name: "", laneIndex: 2), events: []),
    ];

    // Helper to check overlap
    bool overlaps(TableEvent a, TableEvent b) {
      final aStart = a.startTime.hour * 60 + a.startTime.minute;
      final aEnd = a.endTime.hour * 60 + a.endTime.minute;
      final bStart = b.startTime.hour * 60 + b.startTime.minute;
      final bEnd = b.endTime.hour * 60 + b.endTime.minute;
      return aStart < bEnd && bStart < aEnd;
    }

    for (var booking in filteredBookings) {
      DateTime startLocal = booking.startTime.toLocal();
      DateTime endLocal = booking.endTime.toLocal();
      int startHour = startLocal.hour;
      int startMinute = startLocal.minute;
      int endHour = endLocal.hour;
      int endMinute = endLocal.minute;

      // Ensure minimum duration and valid times (same as before)
      if (endHour < startHour ||
          (endHour == startHour && endMinute <= startMinute)) {
        endMinute = startMinute + 30;
        endHour = startHour;
        if (endMinute >= 60) {
          endHour += (endMinute ~/ 60);
          endMinute %= 60;
        }
        if (endHour >= 24) {
          endHour = 23;
          endMinute = 59;
        }
      }
      if (endHour < startHour ||
          (endHour == startHour && endMinute <= startMinute)) {
        continue;
      }

      // Try to place in the first lane with no overlap
      int chosenLane = 0;
      bool placed = false;
      for (int i = 0; i < lanes.length; i++) {
        final eventTemp = TableEvent(
          title:
              booking.description.isNotEmpty
                  ? booking.description
                  : 'Booking #${booking.id}',
          startTime: TableEventTime(hour: startHour, minute: startMinute),
          endTime: TableEventTime(hour: endHour, minute: endMinute),
          laneIndex: i,
          backgroundColor: _getStatusColor(booking.status),
          textStyle: const TextStyle(color: Colors.white, fontSize: 12),
          eventId: booking.id,
        );
        if (lanes[i].events.every((e) => !overlaps(e, eventTemp))) {
          lanes[i].events.add(eventTemp);
          placed = true;
          break;
        }
      }
      // If all lanes overlap, just put in the first lane (fallback)
      if (!placed) {
        final event = TableEvent(
          title:
              booking.description.isNotEmpty
                  ? booking.description
                  : 'Booking #${booking.id}',
          startTime: TableEventTime(hour: startHour, minute: startMinute),
          endTime: TableEventTime(hour: endHour, minute: endMinute),
          laneIndex: 0,
          backgroundColor: _getStatusColor(booking.status),
          textStyle: const TextStyle(color: Colors.white, fontSize: 12),
          eventId: booking.id,
        );
        lanes[0].events.add(event);
      }
    }

    return lanes;
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'AWAITING_BOOKING_CONFIRMATION':
        return Colors.orange;
      case 'INPROGRESS':
        return Colors.green;
      case 'OFFER':
        return Colors.yellow;
      case 'COMPLETED':
        return Colors.blue;
      case 'DECLINED':
        return Colors.red;
      case 'CANCELLED':
        return Colors.red;

      default:
        return Colors.grey;
    }
  }
}
