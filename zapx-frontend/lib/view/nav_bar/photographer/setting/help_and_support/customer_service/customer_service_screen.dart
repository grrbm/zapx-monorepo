import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';

class CustomerServiceScreen extends StatelessWidget {
  const CustomerServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 23.r,
              backgroundImage: const AssetImage(
                  'assets/images/profile_picture.png'), // Sample profile image
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: 'Customer Service',
                  fontSized: 14.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  alignment: TextAlign.start,
                ),
                CustomText(
                  text: 'Online',
                  fontSized: 14.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.green,
                  alignment: TextAlign.start,
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: const [
                SenderChat(
                  message: 'Lorem ipsum dolor sit amet',
                  time: '5:09 AM',
                ),
                ReceiverChat(
                  message:
                      'Lorem ipsum dolor sit amet consectetur. Nisi nam eget viverra pulvinar...',
                  time: '5:09 AM',
                ),
                SenderChat(
                  message: 'Lorem ipsum dolor sit amet',
                  time: '5:09 AM',
                ),
              ],
            ),
          ),
          Column(
            children: [
              Divider(
                color: AppColors.greyColor.withOpacity(0.2),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Type your message',
                          hintStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.greyColor.withOpacity(0.5),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade200,
                          suffixIcon: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: Image(
                                width: 12.w,
                                height: 12.w,
                                image: const AssetImage(
                                    'assets/images/emoji.png')),
                          ),
                          prefixIcon: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: Image(
                                width: 12.w,
                                height: 12.w,
                                image: const AssetImage(
                                    'assets/images/paperclip.png')),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Image(
                        width: 24.w,
                        height: 24.w,
                        image: const AssetImage('assets/images/send_chat.png')),
                    SizedBox(width: 10.w),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ReceiverChat extends StatelessWidget {
  final String message;
  final String time;
  const ReceiverChat({
    super.key,
    required this.message,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.r),
                  topRight: Radius.circular(12.r),
                  bottomRight: Radius.circular(12.r),
                ),
              ),
              child: SizedBox(
                width: 301.w,
                child: CustomText(
                  text: message,
                  fontSized: 14.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.black87,
                  alignment: TextAlign.start,
                ),
              ),
            ),
            SizedBox(
              height: 10.w,
            ),
            CustomText(
              text: time,
              fontSized: 12.0,
              fontWeight: FontWeight.w400,
              color: AppColors.backgroundColor,
              alignment: TextAlign.end,
            ),
          ],
        ),
      ),
    );
  }
}

class SenderChat extends StatelessWidget {
  final String message;
  final String time;
  const SenderChat({
    super.key,
    required this.message,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.backgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.r),
                  topRight: Radius.circular(12.r),
                  bottomLeft: Radius.circular(12.r),
                ),
              ),
              child: CustomText(
                text: message,
                fontSized: 14.0,
                fontWeight: FontWeight.w400,
                color: Colors.white,
                alignment: TextAlign.start,
              ),
            ),
            SizedBox(
              height: 10.w,
            ),
            CustomText(
              text: time,
              fontSized: 12.0,
              fontWeight: FontWeight.w400,
              color: AppColors.backgroundColor,
              alignment: TextAlign.end,
            ),
          ],
        ),
      ),
    );
  }
}
