import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_button.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/view/nav_bar/user/home/filter/widgets/radio_item_widget.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  // List to track selected venue and location types
  List<String> selectedVenues = [];
  List<String> selectedLocations = [];

  List<String> venueTypes = [
    'Studios',
    'Event Venues',
    'Commercial Spaces',
    'Seasonal Locations',
    'Private Spaces',
    'Urban Landmarks',
    'Residential Spaces',
    'Cultural Sites',
    'Unique Locations'
  ];

  List<String> locationTypes = [
    'Nature Spots',
    'Beaches',
    'Lakes/Rivers',
    'Vineyards/Orchards',
    'Amusement Parks/Fairs',
    'Gardens/Botanical Parks',
    'Markets/Bazaars',
    'Airports/Hangars',
    'Countryside Fields',
    'Mountains/Hills',
    'Farms/Ranches',
    'Sports Venues',
    'Bridges/Piers',
    'Rooftop Views',
    'Train Stations/Railroads',
    'Historical Ruins',
    'Countryside Fields',
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
                          EdgeInsets.only(left: 16.w, right: 8.w, top: 16.w),
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
                    SizedBox(height: 20.w),

                    // Venue Types
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const CustomText(
                            text: 'Venue Types:',
                            fontSized: 16.0,
                            fontWeight: FontWeight.w600,
                            color: AppColors.blackColor,
                            alignment: TextAlign.start,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                                border: Border.all(
                                  color: AppColors.backgroundColor,
                                ),
                                borderRadius: BorderRadius.circular(30)),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 4.w, horizontal: 16.w),
                              child: Row(
                                children: [
                                  Image(
                                      width: 18.w,
                                      height: 18.w,
                                      image: const AssetImage(
                                          'assets/images/check.png')),
                                  const CustomText(
                                    text: 'Apply All',
                                    fontSized: 10.0,
                                    color: Colors.teal,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      crossAxisSpacing: 10.w,
                      childAspectRatio: 5.5,
                      physics: const NeverScrollableScrollPhysics(),
                      children: venueTypes.map((String type) {
                        return RadioItem(
                            title: type,
                            groupValues: selectedLocations,
                            onChanged: (value) {
                              setState(() {
                                if (selectedVenues.contains(value)) {
                                  selectedVenues.remove(value);
                                } else {
                                  selectedVenues.add(value);
                                }
                              });
                            });
                      }).toList(),
                    ),

                    SizedBox(height: 20.h),

                    // Location Types
                    Padding(
                      padding: EdgeInsets.only(left: 16.w),
                      child: const CustomText(
                        text: 'Location Types:',
                        fontSized: 16.0,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackColor,
                        alignment: TextAlign.start,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    GridView.count(
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
                      padding: EdgeInsets.only(left: 16.w),
                      child: const CustomText(
                        text: 'Price',
                        fontSized: 16.0,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackColor,
                        alignment: TextAlign.start,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Row(
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
                                    image:
                                        AssetImage('assets/images/dollor.png')),
                              ),
                              hintText: 'Lowest',
                              hintStyle: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.greyColor.withOpacity(0.4)),
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
                                    image:
                                        AssetImage('assets/images/dollor.png')),
                              ),
                              hintText: 'Highest',
                              hintStyle: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.greyColor.withOpacity(0.4)),
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
