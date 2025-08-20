import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MarkerWidget extends StatelessWidget {
  const MarkerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36.w,
      height: 36.w,
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/images/union.png')),
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: 10.w, left: 8.w, right: 8.w),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6.r),
          child: Image(
            width: 30.w,
            height: 30.w,
            image: AssetImage('assets/images/gallery1.png'),
          ),
        ),
      ),
    );
  }
}
