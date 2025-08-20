// import 'package:flutter/material.dart';
// // ignore: depend_on_referenced_packages
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:zapxx/configs/color/color.dart';
// import 'package:zapxx/configs/custom_global_widgets/custom_button.dart';
// import 'package:zapxx/view/nav_bar/user/home/map_slide_screen/widgets/pictures_widget.dart';
// import 'package:zapxx/view/nav_bar/user/home/map_slide_screen/widgets/profile_section.dart';
// import 'package:zapxx/view/nav_bar/user/home/map_slide_screen/widgets/search_section.dart';
// import 'package:zapxx/view/nav_bar/user/home/map_slide_screen/widgets/tabs_section.dart';

// import '../../../user/home/map_slide_screen/widgets/location_details_widget.dart';

// class MapSlideScreen extends StatefulWidget {
//   const MapSlideScreen({super.key});

//   @override
//   State<MapSlideScreen> createState() => _MapSlideScreenState();
// }

// class _MapSlideScreenState extends State<MapSlideScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         body: Container(
//           height: MediaQuery.of(context).size.height,
//           color: AppColors.greyColor.withOpacity(0.3),
//           child: Stack(
//             children: [
//               Image.asset(
//                 'assets/images/map.png',
//                 width: MediaQuery.of(context).size.width,
//                 height: MediaQuery.of(context).size.height,
//                 fit: BoxFit.cover,
//               ),
//               Positioned(top: 50.w, left: 16.w, child: const SearchSection()),
//               Positioned(
//                 bottom: 0,
//                 left: 0,
//                 right: 0,
//                 child: Container(
//                   height: MediaQuery.of(context).size.height * 0.7,
//                   padding: EdgeInsets.symmetric(vertical: 16.w),
//                   decoration: BoxDecoration(
//                     color: AppColors.whiteColor,
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(16.r),
//                       topRight: Radius.circular(16.r),
//                     ),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.1),
//                         blurRadius: 10,
//                         offset: const Offset(0, -1),
//                       ),
//                     ],
//                   ),
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(
//                       vertical: 8.w,
//                       horizontal: 24.w,
//                     ),
//                     child: ListView(
//                       scrollDirection: Axis.vertical,
//                       shrinkWrap: true,
//                       children: [
//                         const ProfileSection(),
//                         SizedBox(height: 16.w),
//                         const LocationDetails(),
//                         SizedBox(height: 16.w),
//                         const PicturesGallery(),
//                         SizedBox(height: 16.w),
//                         TabBar(
//                           labelColor: AppColors.backgroundColor,
//                           labelStyle: TextStyle(
//                             fontSize: 14.sp,
//                             fontWeight: FontWeight.w400,
//                             fontFamily: 'nunito sans',
//                           ),
//                           unselectedLabelColor: Colors.grey,
//                           indicatorColor: AppColors.backgroundColor,
//                           tabs: const [
//                             Tab(text: 'Time Slots'),
//                             Tab(text: 'Reviews'),
//                           ],
//                         ),
//                         const TabSection(),
//                         // SizedBox(height: 30.w),
//                         Center(
//                           child: CustomButton(
//                             title: 'View Details',
//                             onPressed: () {},
//                             btnColor: AppColors.backgroundColor,
//                             btnTextColor: AppColors.whiteColor,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
