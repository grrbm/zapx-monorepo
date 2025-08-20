import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final List<String> galleryPictures = [
    'assets/images/gallery1',
    'assets/images/gallery2',
    'assets/images/gallery3',
    'assets/images/gallery4',
    'assets/images/gallery5',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.blackColor,
          ),
        ),
        title: const CustomText(
          text: 'Gallery Picture',
          fontSized: 18.0,
          fontWeight: FontWeight.w600,
          color: AppColors.blackColor,
        ),
      ),
      body: Expanded(
        child: GridView.builder(
          itemCount: galleryPictures.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3),
          itemBuilder: (context, index) {
            return Stack(children: [
              Container(
                width: 124.w,
                height: 124.w,
                margin: const EdgeInsets.all(1),
                child: Image(
                  image: AssetImage('${galleryPictures[index]}.png'),
                ),
              ),
              Positioned(
                bottom: 10,
                left: 11,
                child: Image(
                  width: 24.w,
                  height: 20.w,
                  image: const AssetImage('assets/images/download.png'),
                ),
              ),
            ]);
          },
        ),
      ),
    );
  }
}
