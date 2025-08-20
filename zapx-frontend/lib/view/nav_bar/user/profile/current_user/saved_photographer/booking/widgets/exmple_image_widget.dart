import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExamplePictureWidget extends StatelessWidget {
  const ExamplePictureWidget({
    super.key,
    required this.image,
    required this.index,
    required this.onDelete,
  });

  final String image;
  final int index;
  final Function(int) onDelete; // Add this

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(right: 10.w),
          width: 70.w,
          height: 70.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
          ),
        ),
        Positioned(
          bottom: 4,
          right: 14,
          child: GestureDetector(
            onTap: () => onDelete(index), // Trigger deletion
            child: Container(
              width: 20.w,
              height: 20.w,
              padding: EdgeInsets.all(4.w),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Image(image: AssetImage('assets/images/delete.png')),
            ),
          ),
        ),
      ],
    );
  }
}
