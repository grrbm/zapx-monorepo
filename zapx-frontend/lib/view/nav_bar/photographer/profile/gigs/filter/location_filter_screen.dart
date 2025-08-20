import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_button.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/view/nav_bar/user/home/filter/widgets/radio_item_widget.dart';

class LocationFilterScreen extends StatefulWidget {
  const LocationFilterScreen({super.key});

  @override
  State<LocationFilterScreen> createState() => _LocationFilterScreenState();
}

class _LocationFilterScreenState extends State<LocationFilterScreen> {
  List<String> selectedLocations = [];

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
              top: 200.w,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.6,
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
