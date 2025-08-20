import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zapxx/configs/app_url.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/controller/post_controller.dart';
import 'package:zapxx/model/user/seller_model.dart';
import 'package:zapxx/repository/home_api/home_http_api_repository.dart';
import 'package:zapxx/view/home/model_insight.dart';
import 'package:zapxx/view/nav_bar/photographer/home/business_builder/business_builder.dart';
import 'package:zapxx/view/nav_bar/photographer/home/creating_post/creating_post.dart';
import 'package:zapxx/view/nav_bar/photographer/home/discover.dart';
import 'package:zapxx/view/nav_bar/photographer/home/home_screen/chart.dart';
import 'package:zapxx/view_model/services/session_manager/session_controller.dart';

class PhotographerHomeScreen extends StatefulWidget {
  const PhotographerHomeScreen({super.key});

  @override
  State<PhotographerHomeScreen> createState() => _PhotographerHomeScreenState();
}

class _PhotographerHomeScreenState extends State<PhotographerHomeScreen> {
  bool isLoading = false;

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  UserResponse? seller;
  Insight? insight;
  LatLng? _currentLocation;
  Future<void> _getUserCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever
      return;
    }

    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });

    // Move the map to the current location
    final controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLng(_currentLocation!));

    // Fetch posts and add markers
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  Future<void> _onMapCreated(GoogleMapController controller) async {
    _controller.complete(controller);
    String style = await rootBundle.loadString('assets/map_style.json');
    controller.setMapStyle(style);
  }

  @override
  void initState() {
    super.initState();
    Get.find<PostController>().fetchPostList();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _getUserCurrentLocation();
      UserResponse data = await fetchSeller(context);
      await SessionController.saveSellerId('sellerId', data.user.seller.id);
      print('Fetched seller ID: ${SessionController.getSellerId('sellerId')}');
      Insight insightData = await fetchWeeklyInsights(context);
      setState(() {
        seller = data;
        insight = insightData;
      });
    });
  }

  Future<UserResponse> fetchSeller(BuildContext context) async {
    try {
      setState(() => isLoading = true);
      HomeHttpApiRepository repository = HomeHttpApiRepository();
      final token = SessionController().authModel.response.token;
      print('Token $token');
      UserResponse seller = await repository.fetchSeller({
        'Authorization': token,
      });
      return seller;
    } catch (e) {
      setState(() => isLoading = false);
      print('Error fetching services: $e');
      return Future.error(e);
    }
  }

  Future<Insight> fetchWeeklyInsights(BuildContext context) async {
    try {
      setState(() => isLoading = true);
      HomeHttpApiRepository repository = HomeHttpApiRepository();
      final token = SessionController().authModel.response.token;

      Insight seller = await repository.fetchWeeklyInsights({
        'Authorization': token,
      });
      return seller;
    } catch (e) {
      setState(() => isLoading = false);
      print('Error fetching Insights: $e');
      return Future.error(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor.withOpacity(.5),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100.h,
              color: AppColors.whiteColor,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Padding(
                  padding: EdgeInsets.only(top: 40.h),
                  child:
                      seller == null
                          ? const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.backgroundColor,
                            ),
                          )
                          : Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: _getGreeting(),
                                    fontSized: 13.sp,
                                    color: AppColors.greyColor.withOpacity(.5),
                                  ),
                                  CustomText(
                                    text:
                                        seller?.user.fullName ??
                                        SessionController()
                                            .authModel
                                            .response
                                            .user
                                            .name ??
                                        'Demo User',
                                    fontSized: 18.sp,
                                    color: AppColors.blackColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ],
                              ),
                              Container(
                                width: 32.h,
                                height: 32.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image:
                                      seller!.user.profileImage?.url == null
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
                                                  seller!
                                                      .user
                                                      .profileImage!
                                                      .url,
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                ),
                              ),
                            ],
                          ),
                ),
              ),
            ),
            Stack(
              children: [
                SizedBox(
                  height:
                      MediaQuery.of(context).size.height *
                      0.2, // Adjust as needed
                  width: MediaQuery.of(context).size.width,
                  child:
                      _currentLocation == null
                          ? const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.backgroundColor,
                            ),
                          )
                          : GoogleMap(
                            onMapCreated: _onMapCreated,
                            initialCameraPosition: CameraPosition(
                              target: _currentLocation!,
                              zoom: 13,
                            ),
                            mapType: MapType.normal,
                            myLocationButtonEnabled: false,
                          ),
                ),
                Positioned(
                  bottom: 10,
                  left: 80.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      const CreatingPost(locationAddress: ''),
                            ),
                          );
                        },
                        child: const CustomTextContainer(
                          text: 'Post on the map',
                          textcolor: AppColors.whiteColor,
                          color: AppColors.backgroundColor,
                          bordercolor: AppColors.backgroundColor,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      GestureDetector(
                        onTap: () {
                          Get.find<PostController>().fetchPostList();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => DiscoverScreen(
                                    currentLocation:
                                        _currentLocation ??
                                        LatLng(
                                          40.70286776438352,
                                          -74.0220780211709,
                                        ),
                                  ),
                            ),
                          );
                        },
                        child: const CustomTextContainer(
                          text: 'Discover Places',
                          textcolor: AppColors.backgroundColor,
                          color: AppColors.whiteColor,
                          bordercolor: AppColors.backgroundColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Container(
                height: 50.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.greyColor.withOpacity(.1),
                      spreadRadius: .11,
                      blurRadius: 1,
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BusinessBuilder(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: 'Build Business Profile',
                          fontSized: 16.sp,
                          color: AppColors.blackColor,
                          fontWeight: FontWeight.w500,
                        ),
                        const Icon(Icons.arrow_forward_ios),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              child: CustomText(
                text: "Today’s Schedule",
                fontSized: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: 1.sw,
              height: 60.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Container(
                      height: 50.h,
                      width: 1.sw - 70.w,
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(10.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.greyColor.withOpacity(.1),
                            spreadRadius: .11,
                            blurRadius: 1,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomText(
                                  text: 'Photoshoot',
                                  fontSized: 17.sp,
                                  color: AppColors.blackColor,
                                  fontWeight: FontWeight.bold,
                                ),
                                Row(
                                  children: [
                                    CustomText(
                                      text: '10:00 AM - 12:00 PM',
                                      fontSized: 12.sp,
                                      color: AppColors.blackColor,
                                    ),
                                    SizedBox(width: 2.w),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.lightTealColor,
                                        border: Border.all(
                                          color: AppColors.greyColor1,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          35.r,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Icon(
                                          Icons.calendar_today_outlined,
                                          size: 14.sp,
                                          color: AppColors.greyColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  size: 14,
                                  color: AppColors.backgroundColor,
                                ),
                                CustomText(
                                  text: '36 Guild Street London, UK ',
                                  fontSized: 12.sp,
                                  color: AppColors.greyColor,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              child: CustomText(
                text: "Weekly Insights",
                fontSized: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            insight == null
                ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.backgroundColor,
                  ),
                )
                : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomCard(
                      text1: insight!.totalBookings.toString(),
                      text2: 'Total \nShoots',
                    ),
                    CustomCard(
                      text1: '\$ ${insight!.totalRevenue.toString()}',
                      text2: 'Estimated \nRevenue',
                    ),
                    CustomCard(
                      text1: insight!.totalHours.toString(),
                      text2: 'Hours \nBooked',
                    ),
                  ],
                ),
            SizedBox(height: 10.h),
            Card(
              color: AppColors.whiteColor,
              child: SizedBox(
                height: 180.h,
                width: 320.w,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: AppointmentBarChart(),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
            //   child: Container(
            //     color: AppColors.whiteColor,
            //     child: ExpansionTileCard(
            //       expandedColor: AppColors.whiteColor,
            //       baseColor: AppColors.whiteColor,
            //       title: CustomText(
            //         text: 'Refer a Friend & Get a Discount',
            //         fontWeight: FontWeight.bold,
            //         fontSized: 16.sp,
            //       ),
            //       children: <Widget>[
            //         Divider(thickness: 1.0, height: 1.0),
            //         Align(
            //           alignment: Alignment.centerLeft,
            //           child: Padding(
            //             padding: EdgeInsets.symmetric(
            //               horizontal: 10.w,
            //               vertical: 8.h,
            //             ),
            //             child: Row(
            //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //               children: [
            //                 Column(
            //                   children: [
            //                     CustomText(
            //                       fontSized: 13.sp,
            //                       text:
            //                           "60% off on the premium for a month and \nthe person referred gets 40% on the \npremium for a month",
            //                     ),
            //                   ],
            //                 ),
            //                 Container(
            //                   height: 30.h,
            //                   width: 60.w,
            //                   decoration: BoxDecoration(
            //                     color: AppColors.backgroundColor,
            //                     borderRadius: BorderRadius.circular(10.r),
            //                   ),
            //                   child: Center(
            //                     child: CustomText(
            //                       text: 'Share',
            //                       fontSized: 13.sp,
            //                       color: AppColors.whiteColor,
            //                     ),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  const CustomCard({super.key, required this.text1, required this.text2});
  final String text1;
  final String text2;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      child: Container(
        height: 90.h,
        width: 110.w,
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              text: text1,
              fontSized: 24.sp,
              color: AppColors.blackColor,
              fontWeight: FontWeight.bold,
            ),
            CustomText(
              text: text2,
              fontSized: 12.sp,
              color: AppColors.greyColor,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTextContainer extends StatelessWidget {
  const CustomTextContainer({
    super.key,
    this.text,
    this.textcolor,
    this.color,
    this.bordercolor,
  });
  final text;
  final textcolor;
  final color;
  final bordercolor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 211.w,
      height: 24.h,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: bordercolor.withOpacity(.5),
            spreadRadius: 1,
            blurRadius: 1,
          ),
        ],
      ),
      child: Center(
        child: CustomText(
          text: text,
          fontSized: 10.sp,
          fontWeight: FontWeight.bold,
          color: textcolor,
        ),
      ),
    );
  }
}
