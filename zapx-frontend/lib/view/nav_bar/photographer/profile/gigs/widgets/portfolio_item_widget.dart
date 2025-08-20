import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';

class PortfolioItemWidget extends StatelessWidget {
  const PortfolioItemWidget({
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
              child: Stack(
                children: [
                  Image(
                    width: 155.w,
                    height: 127.w,
                    fit: BoxFit.fill,
                    image: const AssetImage('assets/images/gallery4.png'),
                  ),
                  Positioned(
                      top: 90.w,
                      left: 10.w,
                      child: Container(
                        width: 46.w,
                        height: 28.w,
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(100.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                                width: 16.w,
                                height: 16.w,
                                image: AssetImage('assets/images/photo.png')),
                            SizedBox(
                              width: 4.w,
                            ),
                            CustomText(
                              text: '1',
                              fontSized: 12.0,
                              fontWeight: FontWeight.w500,
                              color: AppColors.blackColor,
                            ),
                          ],
                        ),
                      ))
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: CustomText(
                text: 'Pet Photography',
                fontSized: 14.0,
                fontWeight: FontWeight.w700,
                color: AppColors.blackColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
