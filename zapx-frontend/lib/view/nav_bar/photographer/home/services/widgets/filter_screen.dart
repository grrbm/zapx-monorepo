import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_button.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/view/nav_bar/user/home/filter/widgets/radio_item_widget.dart';

class ServicesFilterScreen extends StatefulWidget {
  const ServicesFilterScreen({super.key});

  @override
  State<ServicesFilterScreen> createState() => _ServicesFilterScreenState();
}

class _ServicesFilterScreenState extends State<ServicesFilterScreen> {
  List<String> selectedLocations = [];
  bool isPhotographer = false;

  List<String> locationTypes = [
    'Event',
    'Adventure',
    'Commercial',
    'Fine Art',
    'Farewell',
    'Food',
    'Fermion',
    'Sports',
    'Wedding/Documentry',
    'Music Videos',
    'Corporate',
    'Produce',
    'Pet za',
    'Automotive',
    'Social Media Influenser',
    'DIY how to video?',
    'Real Estate',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: AppColors.greyColor.withOpacity(0.3),
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              top: 80.w,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.9,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.r),
                        topRight: Radius.circular(16.r))),
                child: ListView(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.only(left: 23.w, right: 23.w, top: 16.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const CustomText(
                            text: 'Filter',
                            fontSized: 16.0,
                            fontWeight: FontWeight.w700,
                            color: AppColors.blackColor,
                          ),
                          IconButton(
                            icon:
                                const Icon(Icons.close, color: Colors.black45),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isPhotographer = false;
                              });
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    color: !isPhotographer
                                        ? AppColors.backgroundColor
                                        : AppColors.whiteColor,
                                    borderRadius: BorderRadius.circular(7.r)),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 35.w, vertical: 6.w),
                                  child: CustomText(
                                    text: 'Videographers',
                                    fontSized: 15.0,
                                    fontWeight: FontWeight.w700,
                                    color: !isPhotographer
                                        ? AppColors.whiteColor
                                        : AppColors.blackColor,
                                  ),
                                )),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isPhotographer = true;
                              });
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    color: isPhotographer
                                        ? AppColors.backgroundColor
                                        : AppColors.whiteColor,
                                    borderRadius: BorderRadius.circular(7.r)),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.w, vertical: 6.w),
                                  child: CustomText(
                                    text: 'Photographers',
                                    fontSized: 15.0,
                                    fontWeight: FontWeight.w700,
                                    color: isPhotographer
                                        ? AppColors.whiteColor
                                        : AppColors.blackColor,
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.w),
                    Padding(
                      padding: EdgeInsets.only(left: 23.w),
                      child: const CustomText(
                        text: 'Category',
                        fontSized: 16.0,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackColor,
                        alignment: TextAlign.start,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    GridView.count(
                      padding: EdgeInsets.only(left: 10.w, right: 10.w),
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      crossAxisSpacing: 10.w,
                      childAspectRatio: 5.5,
                      physics: const NeverScrollableScrollPhysics(),
                      children: locationTypes.map((String type) {
                        return RadioItem(
                            title: type,
                            groupValues: selectedLocations,
                            onChanged: (value) {
                              setState(() {
                                if (selectedLocations.contains(value)) {
                                  selectedLocations.remove(value);
                                } else {
                                  selectedLocations.add(value);
                                }
                              });
                            });
                      }).toList(),
                    ),
                    SizedBox(height: 20.h),
                    Padding(
                      padding: EdgeInsets.only(left: 23.w),
                      child: const CustomText(
                        text: 'Price',
                        fontSized: 16.0,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackColor,
                        alignment: TextAlign.start,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 155.w,
                            height: 45.w,
                            child: TextFormField(
                              decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: EdgeInsets.only(
                                      left: 16.w, top: 12.w, bottom: 12.w),
                                  child: const Image(
                                      color: AppColors.blackColor,
                                      image: AssetImage(
                                          'assets/images/dollor.png')),
                                ),
                                hintText: 'Lowest',
                                hintStyle: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color:
                                        AppColors.greyColor.withOpacity(0.4)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                  borderSide:
                                      const BorderSide(color: Colors.grey),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          SizedBox(
                            width: 155.w,
                            height: 45.w,
                            child: TextFormField(
                              decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: EdgeInsets.only(
                                      left: 16.w, top: 12.w, bottom: 12.w),
                                  child: const Image(
                                      color: AppColors.blackColor,
                                      image: AssetImage(
                                          'assets/images/dollor.png')),
                                ),
                                hintText: 'Highest',
                                hintStyle: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color:
                                        AppColors.greyColor.withOpacity(0.4)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                  borderSide:
                                      const BorderSide(color: Colors.grey),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(24.w),
                      child: CustomButton(
                          title: 'Apply',
                          onPressed: () {},
                          btnColor: AppColors.backgroundColor,
                          btnTextColor: AppColors.whiteColor),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
