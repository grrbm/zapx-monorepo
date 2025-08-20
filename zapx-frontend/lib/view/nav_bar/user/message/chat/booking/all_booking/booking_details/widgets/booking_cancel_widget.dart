import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapxx/configs/app_url.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/configs/date_format.dart';
import 'package:zapxx/configs/utils.dart';
import 'package:zapxx/view/nav_bar/user/booking/booking_model.dart';
import 'package:zapxx/view/nav_bar/user/message/chat/booking/all_booking/booking_details/booking_details_screen.dart';
import 'package:zapxx/view/nav_bar/user/message/chat/booking/all_booking/booking_details/widgets/dialog_button_widget.dart';
import 'package:zapxx/view_model/services/session_manager/session_controller.dart';
import 'package:http/http.dart' as http;

class BookingCancelWidget extends StatefulWidget {
  final String status;
  final Booking? booking;
  const BookingCancelWidget({super.key, required this.status, this.booking});

  @override
  State<BookingCancelWidget> createState() => _BookingCancelWidgetState();
}

class _BookingCancelWidgetState extends State<BookingCancelWidget> {
  final SessionController _sessionController = SessionController();
  Future<void> cancelBooking(String bookingId) async {
    final token = _sessionController.authModel.response.token;
    final headers = {'Authorization': token};

    final response = await http.post(
      Uri.parse(
        'https://api-zapx.binarymarvels.com/booking/canceled/$bookingId',
      ),
      headers: headers,
    );

    if (response.statusCode == 200) {
      print("Booking cancel successfully.");
    } else {
      throw Exception("Failed to cancel booking: ${response.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 343.w,
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(25.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage:
                          (widget.booking?.consumer?.user.profileImage?.url !=
                                      null &&
                                  widget
                                      .booking!
                                      .consumer!
                                      .user
                                      .profileImage
                                      .url
                                      .isNotEmpty)
                              ? NetworkImage(
                                AppUrl.baseUrl +
                                    "/" +
                                    widget
                                        .booking!
                                        .consumer!
                                        .user
                                        .profileImage
                                        .url,
                              )
                              : const AssetImage(
                                    'assets/images/profile_picture.png',
                                  )
                                  as ImageProvider,
                    ),
                    SizedBox(width: 16.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text:
                              widget.booking?.consumer?.user.fullName ??
                              widget.booking!.clientName ??
                              'Unknown',
                          fontSized: 14.0,
                          fontWeight: FontWeight.w700,
                          color: AppColors.blackColor,
                        ),
                        CustomText(
                          text:
                              'Reference Code: ${widget.booking?.bookingReferenceId ?? 'N/A'}',
                          fontSized: 12.0,
                          color: AppColors.greyColor.withOpacity(0.4),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 12.w),
                const Divider(thickness: 0.3, height: 0),
                SizedBox(height: 12.w),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: 'Status',
                      fontSized: 14.0,
                      fontWeight: FontWeight.w500,
                      color: AppColors.greyColor.withOpacity(0.4),
                    ),
                    Container(
                      width: 76.w,
                      height: 24.w,
                      decoration: BoxDecoration(
                        color:
                            widget.status == 'CANCELED'
                                ? AppColors.redColor.withOpacity(0.05)
                                : AppColors.backgroundColor.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Center(
                        child: CustomText(
                          text: widget.status,
                          fontSized: 12.0,
                          fontWeight: FontWeight.w600,
                          color:
                              widget.status == 'CANCELED'
                                  ? AppColors.redColor
                                  : AppColors.backgroundColor,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.w),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 0.75,
                          color: AppColors.greyColor.withOpacity(0.2),
                        ),
                        borderRadius: BorderRadius.circular(40.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10.w),
                        child: Image(
                          width: 19.w,
                          height: 19.w,
                          fit: BoxFit.contain,
                          image: const AssetImage('assets/images/Calendar.png'),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text:
                              '${formatTime(widget.booking?.startTime?.toString() ?? '')} - ${formatTime(widget.booking?.endTime?.toString() ?? '')} ${formatDate(widget.booking?.date?.toString() ?? '')}',
                          fontSized: 14.0,
                          fontWeight: FontWeight.w600,
                          color: AppColors.blackColor,
                        ),
                        CustomText(
                          text: 'Schedule',
                          fontSized: 12.0,
                          color: AppColors.greyColor.withOpacity(0.4),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 17.w),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 200.w,
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5.r),
                              child: Image(
                                width: 40.w,
                                height: 40.w,
                                fit: BoxFit.contain,
                                image: NetworkImage(
                                  AppUrl.baseUrl +
                                      "/" +
                                      widget
                                          .booking!
                                          .seller
                                          .user
                                          .profileImage
                                          .url,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text:
                                    widget.booking?.seller?.user.fullName ??
                                    'Unknown',
                                fontSized: 14.0,
                                fontWeight: FontWeight.w600,
                                color: AppColors.blackColor,
                              ),
                              CustomText(
                                text: 'Service Provider',
                                fontSized: 12.0,
                                fontWeight: FontWeight.w500,
                                color: AppColors.greyColor.withOpacity(0.4),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 60.w,
                      height: 24.w,
                      child: CustomText(
                        text:
                            '\$${widget.booking?.totalPrice?.toString() ?? '0'}',
                        fontSized: 16.0,
                        fontWeight: FontWeight.w700,
                        color: AppColors.backgroundColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        widget.booking!.status != 'CANCELED' &&
                SessionController().authModel.response.user.role != 'SELLER'
            ? Positioned(
              top: 25.w,
              right: 25.w,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: AppColors.whiteColor,
                        title: const CustomText(
                          text: 'Are you sure to cancel?',
                          fontSized: 19.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.backgroundColor,
                        ),
                        content: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          child: SizedBox(width: 240.w),
                        ),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomButton(
                                color: AppColors.whiteColor,
                                text: 'No',
                                textColor: AppColors.redColor,
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                              SizedBox(width: 16.w),
                              CustomButton(
                                color: AppColors.backgroundColor,
                                text: 'Yes',
                                textColor: AppColors.whiteColor,
                                onTap: () {
                                  cancelBooking(widget.booking!.id.toString())
                                      .then((_) {
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) =>
                                                    BookingDetailsScreen(
                                                      booking: widget.booking,
                                                    ),
                                          ),
                                          (route) => false,
                                        );

                                        Utils.flushBarSuccessMessage(
                                          'Booking successfully canceled',
                                          context,
                                        );
                                      })
                                      .catchError((error) {
                                        print(
                                          "Error canceling booking: $error",
                                        );
                                      });
                                },
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Image(
                  width: 26.w,
                  height: 26.w,
                  image: const AssetImage('assets/images/cancel.png'),
                ),
              ),
            )
            : SizedBox.shrink(),
      ],
    );
  }
}
