import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zapxx/configs/app_url.dart';
import 'package:zapxx/view/nav_bar/user/home/services/widgets/scheduler_type_model.dart';
import 'package:zapxx/view/nav_bar/user/profile/current_user/saved_photographer/reviews/widgets/review_item_widget.dart';

class ReviewsTabNew extends StatelessWidget {
  final double paddingLeft;
  final List<Review>? reviews;

  const ReviewsTabNew({
    super.key,
    required this.paddingLeft,
    required this.reviews,
  });

  @override
  Widget build(BuildContext context) {
    if (reviews == null || reviews!.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: Text('No reviews available'),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.only(left: paddingLeft),
      itemCount: reviews!.length,
      itemBuilder: (context, index) {
        final review = reviews![index];
        return ReviewItemWidget(
          profilePicture:
              review.consumer.user.profileImage != null
                  ? AppUrl.baseUrl +
                      '/' +
                      review.consumer.user.profileImage!.url
                  : 'assets/images/profile_picture.png',
          userName: review.consumer.user.fullName,
          reviewDescription: review.description,
          rating: review.rating.toDouble(),
          date: DateFormat('dd MMM').format(
            DateTime.now(), // Adjust date field as per your API
          ),
          paddingLeft: paddingLeft,
        );
      },
    );
  }
}
