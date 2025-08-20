import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapxx/view/nav_bar/user/profile/current_user/saved_photographer/posts/widgets/availble_slot_widget.dart';
import 'package:zapxx/view/nav_bar/user/profile/current_user/saved_photographer/posts/widgets/duration_selection_widget.dart';
import 'package:zapxx/view/nav_bar/user/profile/current_user/saved_photographer/reviews/reviews_tab.dart';

class TabSection extends StatelessWidget {
  const TabSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280.w,
      child: const TabBarView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DurationSelection(),
              //  AvailableSlots(),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: ReviewsTab(paddingLeft: 0),
          ),
        ],
      ),
    );
  }
}
