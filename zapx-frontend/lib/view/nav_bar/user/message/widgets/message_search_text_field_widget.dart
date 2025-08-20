import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapxx/configs/color/color.dart';

class MessageSearchTextField extends StatelessWidget {
  final TextEditingController searchController;
  const MessageSearchTextField({super.key, required this.searchController});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
      },
      controller: searchController,
      cursorColor: AppColors.blackColor,
      keyboardType: TextInputType.text,
      style: TextStyle(
        color: AppColors.blackColor,
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        fontFamily: 'nunito sans',
      ),
      decoration: InputDecoration(
        hintText: 'Search',
        contentPadding: EdgeInsets.symmetric(vertical: 14.w, horizontal: 10),
        hintStyle: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.greyColor.withOpacity(0.4),
          fontFamily: 'nunito sans',
        ),
        prefixIconConstraints: BoxConstraints(maxHeight: 44.h, maxWidth: 44.w),
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 10.w, right: 10.w),
          child: Image.asset(
            'assets/images/search.png',
            color: AppColors.greyColor.withOpacity(0.4),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.greyColor.withOpacity(0.4),
            width: 0.0,
          ),
          borderRadius: BorderRadius.circular(13.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13.r),
          borderSide: BorderSide(color: AppColors.greyColor.withOpacity(0.4)),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.greyColor.withOpacity(0.4)),
          borderRadius: BorderRadius.circular(13.r),
        ),
      ),
    );
  }
}
