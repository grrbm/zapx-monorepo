import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_app_bar.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_button.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/view/nav_bar/user/message/chat/chat_screen.dart';

class DeliverScreen extends StatefulWidget {
  const DeliverScreen({super.key});

  @override
  State<DeliverScreen> createState() => _DeliverScreenState();
}

class _DeliverScreenState extends State<DeliverScreen> {
  final List<String> images = [
    'assets/images/gallery1.png',
    'assets/images/gallery2.png',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: const CustomAppBar(title: 'Deliver'),
      body: Column(
        children: [
          Divider(color: AppColors.greyColor.withOpacity(0.4)),
          Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: 'Add Notes',
                  fontSized: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackColor,
                  alignment: TextAlign.start,
                ),
                SizedBox(height: 8.w),
                TextField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 15.w,
                    ),
                    hintText: 'Add Notes here',
                    hintStyle: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Nunito Sans',
                      color: AppColors.greyColor.withOpacity(0.5),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 16.w),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.w),
                  child: const CustomText(
                    text: 'Add Photos',
                    fontSized: 14.0,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackColor,
                    alignment: TextAlign.left,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 70.w,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: 70.w,
                          height: 70.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: const DecorationImage(
                              image: AssetImage('assets/images/dot_border.png'),
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.add,
                              size: 28,
                              color: AppColors.backgroundColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: ListView.builder(
                          itemCount: images.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(right: 10.w),
                              width: 70.w,
                              height: 70.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: AssetImage(images[index]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 320.w),
                CustomButton(
                  title: 'Deliver',
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => const ChatScreen(
                              id: '1',
                              userId: '2',
                              name: 'Grace',
                              image: 'assets/images/profile_picture.png',
                            ),
                      ),
                    );
                  },
                  btnColor: AppColors.backgroundColor,
                  btnTextColor: AppColors.whiteColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
