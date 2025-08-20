import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';

class MessageMediaItemWidget extends StatelessWidget {
  final String message;
  final bool isSent;
  const MessageMediaItemWidget({
    super.key,
    required this.message,
    required this.isSent,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment:
              isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              width: 306.w,
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: isSent
                    ? AppColors.greyColor.withOpacity(.2)
                    : AppColors.backgroundColor.withOpacity(0.1),
                borderRadius: isSent
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        topRight: Radius.circular(10))
                    : const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                        topRight: Radius.circular(10)),
              ),
              child: CustomText(
                text: message,
                fontSized: 12.sp,
                color: AppColors.blackColor,
                alignment: TextAlign.start,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.w),
              child: Row(
                mainAxisAlignment:
                    isSent ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image(
                        width: 120.w,
                        height: 120.w,
                        fit: BoxFit.cover,
                        image: const AssetImage('assets/images/gallery1.png')),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image(
                        width: 120.w,
                        height: 120.w,
                        fit: BoxFit.cover,
                        image: const AssetImage('assets/images/gallery2.png')),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment:
                  isSent ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                CustomText(
                  text: '12:00 PM',
                  fontSized: 10.0,
                  color: AppColors.greyColor.withOpacity(0.4),
                ),
                SizedBox(
                  width: 4.w,
                ),
                Image(
                    width: 14.w,
                    height: 14.w,
                    image: const AssetImage('assets/images/seen.png')),
              ],
            )
          ],
        ),
      ),
    );
  }
}
