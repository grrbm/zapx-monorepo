import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_button.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/repository/home_api/home_http_api_repository.dart';
import 'package:zapxx/view/nav_bar/user/home/filter/location_model.dart';
import 'package:zapxx/view/nav_bar/user/home/filter/venue_model.dart';
import 'package:zapxx/view/nav_bar/user/home/filter/widgets/new_radio_item.dart';
import 'package:zapxx/view_model/services/session_manager/session_controller.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();
  List<String> selectedVenues = [];
  List<String> selectedLocations = [];
  final List<Venue> venues = [];
  final List<Locations> locations = [];
  bool isLoadingVenue = true;
  bool isLoadingLocation = true;
  // Function to select/deselect all locations
  void toggleSelectAllLocations() {
    setState(() {
      if (selectedLocations.length == locations.length) {
        selectedLocations.clear(); // Deselect all
      } else {
        selectedLocations =
            locations
                .map((location) => location.name.toString())
                .toList(); // Select all
      }
      if (selectedVenues.length == venues.length) {
        selectedVenues.clear(); // Deselect all
      } else {
        selectedVenues =
            venues.map((venue) => venue.name.toString()).toList(); // Select all
      }
    });
  }

  void fetchVenues() async {
    try {
      HomeHttpApiRepository repository = HomeHttpApiRepository();
      final token = SessionController().authModel.response.token;
      VenueResponse venueResponse = await repository.fetchVenueList({
        'Authorization': token,
      });
      setState(() {
        venues.addAll(venueResponse.venues);
        isLoadingVenue = false;
      });
    } catch (e) {
      print("Error fetching venues: $e");
      setState(() => isLoadingVenue = false);
    }
  }

  void fetchLocation() async {
    try {
      HomeHttpApiRepository repository = HomeHttpApiRepository();
      final token = SessionController().authModel.response.token;
      LocationModel locationModel = await repository.fetchLocationList({
        'Authorization': token,
      });
      setState(() {
        locations.addAll(locationModel.locations);
        isLoadingLocation = false;
      });
    } catch (e) {
      print("Error fetching locations: $e");
      setState(() => isLoadingLocation = false);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchVenues();
    fetchLocation();
  }

  void _applyFilters() {
    final filters = {
      if (selectedLocations.isNotEmpty) 'locationType': selectedLocations,
      if (selectedVenues.isNotEmpty) 'venueType': selectedVenues,
      // Add other filters here if needed
      if (_minPriceController.text.isNotEmpty)
        'hourlyRateMin': _minPriceController.text,
      if (_maxPriceController.text.isNotEmpty)
        'hourlyRateMax': _maxPriceController.text,
    };

    // Clear filters if all values are empty
    if (filters.isEmpty) {
      Navigator.pop(context, {});
    } else {
      Navigator.pop(context, filters);
    }
  }

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
                    topRight: Radius.circular(16.r),
                  ),
                ),
                child: ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: 16.w,
                        right: 8.w,
                        top: 16.w,
                      ),
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
                            icon: const Icon(
                              Icons.close,
                              color: Colors.black45,
                            ),
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
                          GestureDetector(
                            onTap: toggleSelectAllLocations,
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                                border: Border.all(
                                  color: AppColors.backgroundColor,
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 4.w,
                                  horizontal: 16.w,
                                ),
                                child: Row(
                                  children: [
                                    Image(
                                      width: 18.w,
                                      height: 18.w,
                                      image: const AssetImage(
                                        'assets/images/check.png',
                                      ),
                                    ),
                                    const CustomText(
                                      text: 'Apply All',
                                      fontSized: 10.0,
                                      color: Colors.teal,
                                    ),
                                  ],
                                ),
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
                      mainAxisSpacing: 10.w,
                      childAspectRatio: 5.5,
                      physics: const NeverScrollableScrollPhysics(),
                      children:
                          venues.map((venue) {
                            return RadioItemNew(
                              title: venue.name,
                              value: venue.name.toString(),
                              groupValues: selectedVenues,
                              onChanged: (value) {
                                setState(() {
                                  if (selectedVenues.contains(value)) {
                                    selectedVenues.remove(value);
                                  } else {
                                    selectedVenues.add(value!);
                                  }
                                });
                              },
                            );
                          }).toList(),
                    ),

                    SizedBox(height: 20.h),

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
                      mainAxisSpacing: 10.w,
                      childAspectRatio: 5.5,
                      physics: const NeverScrollableScrollPhysics(),
                      children:
                          locations.map((location) {
                            return RadioItemNew(
                              value: location.name.toString(),
                              title: location.name,
                              groupValues: selectedLocations,
                              onChanged: (value) {
                                setState(() {
                                  if (selectedLocations.contains(value)) {
                                    selectedLocations.remove(value);
                                  } else {
                                    selectedLocations.add(value!);
                                  }
                                });
                              },
                            );
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
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.blackColor,
                            ),
                            controller: _minPriceController,
                            decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(
                                  left: 16.w,
                                  top: 12.w,
                                  bottom: 12.w,
                                ),
                                child: const Image(
                                  color: AppColors.blackColor,
                                  image: AssetImage('assets/images/dollor.png'),
                                ),
                              ),
                              hintText: 'Lowest',
                              hintStyle: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.greyColor.withOpacity(0.4),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.r),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
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
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.blackColor,
                            ),
                            controller: _maxPriceController,
                            decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(
                                  left: 16.w,
                                  top: 12.w,
                                  bottom: 12.w,
                                ),
                                child: const Image(
                                  color: AppColors.blackColor,
                                  image: AssetImage('assets/images/dollor.png'),
                                ),
                              ),
                              hintText: 'Highest',
                              hintStyle: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.greyColor.withOpacity(0.4),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.r),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
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
                        onPressed: () {
                          // Handle Apply
                          _applyFilters();
                          print(selectedLocations);
                          print(selectedVenues);
                        },
                        btnColor: AppColors.backgroundColor,
                        btnTextColor: AppColors.whiteColor,
                      ),
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
