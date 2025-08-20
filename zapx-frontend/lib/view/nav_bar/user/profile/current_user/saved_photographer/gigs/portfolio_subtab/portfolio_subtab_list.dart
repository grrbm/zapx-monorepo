import 'package:flutter/material.dart';
import 'package:zapxx/configs/app_url.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/view/nav_bar/user/profile/current_user/saved_photographer/gigs/portfolio_subtab/portfolio_details_screen.dart';
import 'package:zapxx/view/nav_bar/user/profile/current_user/saved_photographer/gigs/portfolio_subtab/portfolio_model.dart';
import 'package:zapxx/view/nav_bar/user/profile/current_user/saved_photographer/gigs/widgets/portfolio_item_widget.dart';

class PortfolioList extends StatefulWidget {
  const PortfolioList({super.key, required this.portfolioResponse});
  final PortfolioResponse portfolioResponse;
  @override
  State<PortfolioList> createState() => _PortfolioListState();
}

class _PortfolioListState extends State<PortfolioList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 155 / 180,
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => PortfolioDetailsScreen(
                          portfolio: widget.portfolioResponse.portfolio[index],
                        ),
                  ),
                );
              },
              child: PortfolioItemWidget(
                Imageurl:
                    "${AppUrl.baseUrl + "/" + widget.portfolioResponse!.portfolio[index].images.first.url.toString()}",
                text1: widget.portfolioResponse.portfolio[index].title,
              ),
            );
          },
          itemCount: widget.portfolioResponse.portfolio.length,
        ),
      ),
    );
  }
}
