import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';

import '../../../../../configs/color/color.dart';

class MessageTile extends StatelessWidget {
  final String image;
  final String name;
  final String message;
  final String time;
  final int? unreadCount;

  const MessageTile({
    super.key,
    required this.image,
    required this.name,
    required this.message,
    required this.time,
    this.unreadCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.w),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage(image),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: name,
                  fontSized: 14.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
                CustomText(
                  text: message,
                  fontSized: 13.0,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomText(
                text: time,
                fontSized: 11.0,
                color: Colors.grey,
              ),
              const SizedBox(height: 4),
              if (unreadCount != null && unreadCount! > 0)
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: AppColors.backgroundColor,
                    shape: BoxShape.circle,
                  ),
                  child: CustomText(
                    text: unreadCount.toString(),
                    fontSized: 12.0,
                    color: Colors.white,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
