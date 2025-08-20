import 'package:flutter/material.dart';
import 'package:zapxx/view/nav_bar/user/home/services/widgets/scheduler_type_model.dart';
import 'package:zapxx/view/nav_bar/user/profile/current_user/saved_photographer/posts/widgets/duration_selection_widget.dart';
import 'package:zapxx/view/nav_bar/user/profile/current_user/saved_photographer/reviews/review_tab_new.dart';
import 'package:zapxx/view/nav_bar/user/profile/other_user/widgets/time_slot_tab_widget.dart';

class TabSection extends StatelessWidget {
  const TabSection({
    super.key,
    required this.timeScheduler,
    required this.review,
  });
  final ServiceSchedulerType timeScheduler;
  final ServiceSchedulerType review;

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        TimeSlotTabWidget(
          timeSlots: timeScheduler.schedulerDates,
          sellerId: timeScheduler.seller.id,
        ),

        Padding(
          padding: EdgeInsets.all(8.0),
          child: ReviewsTabNew(paddingLeft: 0, reviews: review.seller.reviews),
        ),
      ],
    );
  }
}
