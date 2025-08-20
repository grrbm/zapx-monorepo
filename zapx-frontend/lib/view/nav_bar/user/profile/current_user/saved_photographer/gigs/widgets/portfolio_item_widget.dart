import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';

class PortfolioItemWidget extends StatelessWidget {
  final String Imageurl;
  final String text1;
  const PortfolioItemWidget({
    required this.Imageurl,
    required this.text1,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 155.w,
      height: 180.w,
      child: Card(
        color: AppColors.whiteColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: Image(
                width: 155.w,
                height: 127.w,
                fit: BoxFit.fill,
                image: Image.network(Imageurl).image,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: CustomText(
                text: text1,
                fontSized: 14.0,
                fontWeight: FontWeight.w700,
                color: AppColors.blackColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
