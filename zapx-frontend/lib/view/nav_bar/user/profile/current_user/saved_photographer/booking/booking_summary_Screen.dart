import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_app_bar.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_button.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/configs/utils.dart';
import 'package:zapxx/view/nav_bar/user/home/services/widgets/scheduler_type_model.dart';
import 'package:zapxx/view/nav_bar/user/profile/current_user/saved_photographer/booking/card_model.dart';
import 'package:zapxx/view/nav_bar/user/profile/current_user/saved_photographer/booking/widgets/summary_row_item_widget.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:zapxx/view/nav_bar/user/user_nav_bar.dart';
import 'package:zapxx/view_model/services/session_manager/session_controller.dart';
import 'package:zapxx/view/nav_bar/user/profile/current_user/saved_photographer/booking/full_screen_timeslot_viewer.dart';

class BookingSummaryScreen extends StatefulWidget {
  final int id;
  final String duration;
  final String description;
  final String addNotes;
  final List<String> images;
  final Map<String, String>? selectedSlot;
  const BookingSummaryScreen({
    super.key,
    required this.id,
    required this.selectedSlot,
    required this.addNotes,
    required this.description,
    required this.images,
    required this.duration,
  });

  @override
  State<BookingSummaryScreen> createState() => _BookingSummaryScreenState();
}

class _BookingSummaryScreenState extends State<BookingSummaryScreen> {
  bool loading = false;
  bool enable = false;
  String? selectedPaymentMethodId;
  CardModel? selectedCard;
  late Future<List<CardModel>> _cardsFuture;

  @override
  void initState() {
    super.initState();
    _cardsFuture = fetchCards();
  }

  final SessionController _sessionController = SessionController();

  Future<List<CardModel>> fetchCards() async {
    final token = _sessionController.authModel.response.token;
    final headers = {'Authorization': token};

    final response = await http.get(
      Uri.parse('https://api-zapx.binarymarvels.com/stripe/get-cards'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List cardsJson = json.decode(response.body)['cards'];
      return cardsJson.map((json) => CardModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load cards");
    }
  }

  Future<void> refreshCards() async {
    setState(() {
      _cardsFuture = fetchCards();
    });
  }

  Future<String> fetchSetupIntentClientSecret() async {
    final token = _sessionController.authModel.response.token;
    final headers = {'Authorization': token};
    final response = await http.get(
      Uri.parse('https://api-zapx.binarymarvels.com/stripe/setup-intent'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['clientSecret'];
    } else {
      throw Exception("Failed to fetch client secret");
    }
  }

  Future<void> saveCard(String paymentMethodId) async {
    final token = _sessionController.authModel.response.token;
    final headers = {
      'Authorization': token,
      'Content-Type': 'application/json',
    };
    final body = json.encode({'cardId': paymentMethodId, 'isPrimary': true});

    final response = await http.post(
      Uri.parse('https://api-zapx.binarymarvels.com/stripe/save-card'),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      print("Card saved successfully.");
    } else {
      throw Exception("Failed to save card: ${response.body}");
    }
  }

  Future<void> payBookingApi(String paymentMethodId, String booking) async {
    final token = _sessionController.authModel.response.token;
    final headers = {
      'Authorization': token,
      'Content-Type': 'application/json',
    };
    final body = json.encode({
      'paymentMethodId': paymentMethodId,
      'bookingId': booking,
    });

    final response = await http.post(
      Uri.parse('https://api-zapx.binarymarvels.com/stripe/payment'),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      print((response.body));
      print("booking done successfully.");
    } else {
      throw Exception("Failed to add booking: ${response.body}");
    }
  }

  // NEW FUNCTION: Confirm booking after payment
  Future<void> confirmBooking(String bookingId) async {
    final token = _sessionController.authModel.response.token;
    final headers = {'Authorization': token};

    final response = await http.post(
      Uri.parse(
        'https://api-zapx.binarymarvels.com/booking/confirmed/$bookingId',
      ),
      headers: headers,
    );

    if (response.statusCode == 200) {
      print("Booking confirmed successfully.");
    } else {
      throw Exception("Failed to confirm booking: ${response.body}");
    }
  }

  String _formatTimeRange(Map<String, String> slot) {
    final startTime = slot['startTime'] ?? '';
    final endTime = slot['endTime'] ?? '';
    return '$startTime - $endTime';
  }

  @override
  Widget build(BuildContext context) {
    String timeRange = 'No timeslot selected';

    if (widget.selectedSlot != null) {
      timeRange = _formatTimeRange(widget.selectedSlot!);
    }

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: const CustomAppBar(title: 'Booking Summary'),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 23.w),
              Container(
                width: 327.w,
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  border: Border.all(
                    width: 1.w,
                    color: AppColors.greyColor.withOpacity(0.1),
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20.0.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SummaryRowItem(
                        description: widget.duration,
                        title: 'Duration',
                        fontWeight: FontWeight.w400,
                      ),
                      SizedBox(height: 16.w),
                      GestureDetector(
                        onTap: () {},
                        child: SummaryRowItem(
                          description: timeRange,
                          title: 'Timeslot',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 16.w),
                      SummaryRowItem(
                        description: widget.addNotes,
                        title: 'Notes',
                        fontWeight: FontWeight.w400,
                      ),
                      SizedBox(height: 16.w),
                      SummaryRowItem(
                        description: widget.description,
                        title: 'Description',
                        fontWeight: FontWeight.w400,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.w),
                        child: const CustomText(
                          text: 'Example Pictures',
                          fontSized: 14.0,
                          color: AppColors.blackColor,
                          alignment: TextAlign.left,
                        ),
                      ),
                      SizedBox(
                        height: 74.w,
                        child: ListView.builder(
                          itemCount: widget.images.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(right: 10.w),
                              width: 70.w,
                              height: 70.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: AssetImage(widget.images[index]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.w),

              Container(
                width: 327.w,
                height: 72.w,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1.w,
                    color: AppColors.greyColor.withOpacity(0.1),
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image(
                            width: 50.w,
                            height: 37.w,
                            image: const AssetImage('assets/images/stripe.png'),
                          ),

                          GestureDetector(
                            onTap: () async {
                              try {
                                // Fetch client secret from API
                                final setupIntentClientSecret =
                                    await fetchSetupIntentClientSecret();

                                // Initialize the payment sheet
                                await Stripe.instance.initPaymentSheet(
                                  paymentSheetParameters:
                                      SetupPaymentSheetParameters(
                                        setupIntentClientSecret:
                                            setupIntentClientSecret,
                                        style: ThemeMode.light,
                                        merchantDisplayName: 'Zapx',
                                      ),
                                );

                                // Present the payment sheet to the user
                                await Stripe.instance.presentPaymentSheet();
                                final setupIntent = await Stripe.instance
                                    .retrieveSetupIntent(
                                      setupIntentClientSecret,
                                    );

                                if (setupIntent.paymentMethodId.isNotEmpty) {
                                  // Save payment method to backend
                                  await saveCard(setupIntent.paymentMethodId);

                                  // Refresh cards list
                                  await refreshCards();

                                  // Automatically select the new card
                                  setState(() {
                                    selectedPaymentMethodId =
                                        setupIntent.paymentMethodId;
                                    enable = true;
                                  });

                                  Utils.flushBarSuccessMessage(
                                    "Card saved successfully!",
                                    context,
                                  );
                                } else {
                                  throw Exception(
                                    "Payment method ID not found",
                                  );
                                }
                              } on StripeException catch (e) {
                                print(
                                  "Payment failed: ${e.error.localizedMessage}",
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Payment failed: ${e.error.localizedMessage}",
                                    ),
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Error: $e")),
                                );
                              }
                            },
                            child: const CustomText(
                              text: 'Add New Card',
                              fontSized: 14.0,
                              fontWeight: FontWeight.w600,
                              color: AppColors.backgroundColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 23.w),
              // Card List Section with selection
              FutureBuilder<List<CardModel>>(
                future: _cardsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('No cards available');
                  } else {
                    final cards = snapshot.data!;

                    return Column(
                      children:
                          cards.map((card) {
                            final isSelected =
                                selectedPaymentMethodId == card.paymentMethodId;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedPaymentMethodId =
                                      card.paymentMethodId;
                                  selectedCard = card;
                                  enable = true;
                                });
                                print(selectedPaymentMethodId);
                              },
                              child: Container(
                                width: 327.w,
                                margin: EdgeInsets.only(bottom: 12.h),
                                padding: EdgeInsets.all(16.w),
                                decoration: BoxDecoration(
                                  color:
                                      isSelected
                                          ? AppColors.backgroundColor
                                              .withOpacity(0.1)
                                          : AppColors.whiteColor,
                                  border: Border.all(
                                    color:
                                        isSelected
                                            ? AppColors.backgroundColor
                                            : AppColors.greyColor.withOpacity(
                                              0.2,
                                            ),
                                    width: isSelected ? 2.w : 1.w,
                                  ),
                                  borderRadius: BorderRadius.circular(12.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Card ID: ${card.id}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.sp,
                                            color: AppColors.blackColor,
                                          ),
                                        ),
                                        if (isSelected)
                                          Icon(
                                            Icons.check_circle,
                                            color: AppColors.backgroundColor,
                                            size: 20.w,
                                          ),
                                      ],
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      'Card: **** **** **** ${card.paymentMethodId.substring(card.paymentMethodId.length - 4)}',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: AppColors.greyColor,
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      card.isPrimary
                                          ? 'Primary Card'
                                          : 'Secondary Card',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color:
                                            card.isPrimary
                                                ? AppColors.backgroundColor
                                                : AppColors.greyColor,
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      'Created: ${DateFormat('MMM dd, yyyy').format(card.createdAt)}',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: AppColors.greyColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                    );
                  }
                },
              ),
              SizedBox(height: 16.w),

              CustomButton(
                loading: loading,
                title: 'Confirm Booking',
                onPressed: () async {
                  setState(() {
                    loading = true;
                  });
                  if (!enable) {
                    Utils.flushBarErrorMessage(
                      "Please add a card to confirm booking",
                      context,
                    );
                    return;
                  }
                  // Call the API to pay for the booking
                  await payBookingApi(
                        selectedPaymentMethodId!,
                        widget.id.toString(),
                      )
                      .then((_) async {
                        loading = false;
                        Utils.flushBarSuccessMessage(
                          "Booking confirmed successfully!",
                          context,
                        );
                        await confirmBooking(widget.id.toString());
                        Future.delayed(const Duration(seconds: 2), () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const UserNavBar(),
                            ),
                          );
                        });
                      })
                      .catchError((error) {
                        setState(() {
                          loading = false;
                        });
                        Utils.flushBarErrorMessage(
                          "Failed to confirm booking: $error",
                          context,
                        );
                      });
                },
                btnColor: enable ? AppColors.backgroundColor : Colors.grey,
                btnTextColor: AppColors.whiteColor,
              ),
              SizedBox(height: 12.h),
            ],
          ),
        ),
      ),
    );
  }
}
