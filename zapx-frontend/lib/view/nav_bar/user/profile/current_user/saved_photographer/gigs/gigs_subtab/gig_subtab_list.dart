import 'package:flutter/material.dart';
import 'package:zapxx/view/nav_bar/user/profile/current_user/saved_photographer/gigs/widgets/gig_item_widget.dart';

class GigsList extends StatelessWidget {
  const GigsList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
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
    );
  }
}
