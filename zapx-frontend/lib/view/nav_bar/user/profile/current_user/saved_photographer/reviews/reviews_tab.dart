import 'package:flutter/material.dart';
import 'package:zapxx/view/nav_bar/user/profile/current_user/saved_photographer/reviews/widgets/review_item_widget.dart';

class ReviewsTab extends StatelessWidget {
  final double paddingLeft;
  const ReviewsTab({super.key, required this.paddingLeft});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        itemCount: 2,
        // physics: const ScrollPhysics(parent: NeverScrollableScrollPhysics()),
        itemBuilder: (context, index) {
          return ReviewItemWidget(
            profilePicture: 'assets/images/profile_picture.png',
            userName: 'Rocks Velkenjien',
            reviewDescription:
                'Cinemas is the ultimate experience to see new movies in Gold Class or Vmax. Find a cinema near you.',
            rating: 3.0,
            date: '10 Feb',
            paddingLeft: paddingLeft,
          );
        },
      ),
    );
  }
}
