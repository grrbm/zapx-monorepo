import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';

class MessageItem extends StatelessWidget {
  final String message;
  final bool isSent;
  const MessageItem({
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
                    ? AppColors.greyColor.withOpacity(0.2)
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
