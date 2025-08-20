import 'package:flutter/material.dart';
import 'package:zapxx/configs/app_url.dart';
import 'package:zapxx/model/user/seller_review_model.dart';
import 'package:zapxx/view/nav_bar/user/profile/current_user/saved_photographer/reviews/widgets/review_item_widget.dart';
import 'package:intl/intl.dart';

class ReviewsTabSeller extends StatelessWidget {
  final double paddingLeft;
  final SellerReviewModel sellerReview;
  const ReviewsTabSeller({
    super.key,
    required this.paddingLeft,
    required this.sellerReview,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        itemCount: sellerReview.reviews.length,
        // physics: const ScrollPhysics(parent: NeverScrollableScrollPhysics()),
        itemBuilder: (context, index) {
          final review = sellerReview.reviews[index];
          return ReviewItemWidget(
            profilePicture:
                review.consumer.user.profileImage != null
                    ? AppUrl.baseUrl +
                        '/' +
                        review.consumer.user.profileImage.url
                    : 'assets/images/profile_picture.png',
            userName: review.consumer.user.fullName,
            reviewDescription: review.description,
            rating: review.rating.toDouble(),
            date: DateFormat('dd MMM').format(
              review.createdAt, // Adjust date field as per your API
            ),
            paddingLeft: paddingLeft,
          );
        },
      ),
    );
  }
}
