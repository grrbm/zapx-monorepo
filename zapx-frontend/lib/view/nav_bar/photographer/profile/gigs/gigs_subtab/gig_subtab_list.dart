import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/view/nav_bar/photographer/profile/gigs/filter/location_filter_screen.dart';
import 'package:zapxx/view/nav_bar/photographer/profile/gigs/filter/venue_filter_screen.dart';
import 'package:zapxx/view/nav_bar/user/profile/current_user/saved_photographer/gigs/widgets/gig_item_widget.dart';

class GigsList extends StatelessWidget {
  const GigsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20.r)),
                  ),
                  builder: (context) => const VenueFilterScreen(),
                );
              },
              child: Row(
                children: [
                  CustomText(
                    text: 'Venue Type',
                    fontSized: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackColor,
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  Image(
                      width: 18.w,
                      height: 18.w,
                      image: const AssetImage('assets/images/filter.png'))
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20.r)),
                  ),
                  builder: (context) => const LocationFilterScreen(),
                );
              },
              child: Row(
                children: [
                  CustomText(
                    text: 'Location',
                    fontSized: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackColor,
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  Image(
                      width: 18.w,
                      height: 18.w,
                      image: const AssetImage('assets/images/filter.png'))
                ],
              ),
            )
          ],
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(8.0),
            children: const [
              GigCard(
                imageUrl: 'assets/images/gallery1.png',
                title: 'Pet photography',
                location: 'New York, NY',
                price: 25.98,
              ),
              GigCard(
                imageUrl: 'assets/images/gallery2.png',
                title: 'Maternity',
                location: 'Los Angeles, CA',
                price: 35.50,
              ),
              GigCard(
                imageUrl: 'assets/images/gallery1.png',
                title: 'Pet photography',
                location: 'New York, NY',
                price: 25.98,
              ),
              GigCard(
                imageUrl: 'assets/images/gallery2.png',
                title: 'Maternity',
                location: 'Los Angeles, CA',
                price: 35.50,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
