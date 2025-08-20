import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/utils.dart';
import 'package:zapxx/model/selected_location_model.dart';

import '../../../../../controller/post_controller.dart';
import '../../../../../model/selected_venue_model.dart';
import 'create_location_type.dart';
import 'create_venue_type.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Get.find<PostController>().fetchVenueType();
      Get.find<PostController>().fetchLocationType();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Categories',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: GetBuilder<PostController>(
        builder: (PostController postCtrl) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text(
                  "Venue Type",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                if (postCtrl.venueTypeModel == null)
                  progressIndicator()
                else
                  Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        postCtrl.venueTypeModel?.venue?.map((venue) {
                          bool isSelected = postCtrl.selectedVenues.contains(
                            SelectedVenueModel(
                              id: venue.id!,
                              name: venue.name ?? 'Unknown',
                            ),
                          );

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                SelectedVenueModel selectedVenue =
                                    SelectedVenueModel(
                                      id: venue.id!,
                                      name: venue.name ?? 'Unknown',
                                    );

                                if (isSelected) {
                                  postCtrl.selectedVenues.remove(
                                    selectedVenue,
                                  ); // Unselect
                                } else {
                                  postCtrl.selectedVenues.add(
                                    selectedVenue,
                                  ); // Select
                                }
                              });
                              Get.find<PostController>().update();
                              print(
                                'Selected Venues: ${postCtrl.selectedVenues.map((venue) => venue.id).toList()}',
                              );
                            },
                            child: IntrinsicWidth(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      isSelected
                                          ? AppColors.backgroundColor
                                          : Colors.white,
                                  border: Border.all(
                                    color:
                                        isSelected
                                            ? Colors.transparent
                                            : Colors.grey,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    venue.name ?? 'Unknown',
                                    style: TextStyle(
                                      color:
                                          isSelected
                                              ? Colors.white
                                              : Colors.grey,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList() ??
                        [],
                  ),

                SizedBox(height: 25),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateVenueType(),
                      ),
                    );
                  },
                  child: DottedBorder(
                    color: Colors.grey,
                    strokeWidth: 2,
                    dashPattern: [6, 3],
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(12),
                    child: Container(
                      width: double.infinity,
                      height: 40,
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(
                          Icons.add,
                          color: AppColors.backgroundColor,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50),
                Text(
                  "Location Type",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                if (postCtrl.locationTypeModel == null)
                  progressIndicator()
                else
                  Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        postCtrl.locationTypeModel?.locations?.map((location) {
                          bool isSelected = postCtrl.selectedLocations.contains(
                            SelectedLocationModel(
                              id: location.id!,
                              name: location.name ?? 'Unknown',
                            ),
                          );

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                SelectedLocationModel selectedVenue =
                                    SelectedLocationModel(
                                      id: location.id!,
                                      name: location.name ?? 'Unknown',
                                    );

                                if (isSelected) {
                                  postCtrl.selectedLocations.remove(
                                    selectedVenue,
                                  ); // Unselect
                                } else {
                                  postCtrl.selectedLocations.add(
                                    selectedVenue,
                                  ); // Select
                                }
                              });
                              Get.find<PostController>().update();
                              print(
                                'Selected Locations: ${postCtrl.selectedLocations.map((location) => location.id).toList()}',
                              );
                            },
                            child: IntrinsicWidth(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      isSelected
                                          ? AppColors.backgroundColor
                                          : Colors.white,
                                  border: Border.all(
                                    color:
                                        isSelected
                                            ? Colors.transparent
                                            : Colors.grey,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    location.name ?? 'Unknown',
                                    style: TextStyle(
                                      color:
                                          isSelected
                                              ? Colors.white
                                              : Colors.grey,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList() ??
                        [],
                  ),
                SizedBox(height: 25),
                GestureDetector(
                  onTap: () {
                    Get.to(() => CreateLocationType());
                  },
                  child: DottedBorder(
                    color: Colors.grey,
                    strokeWidth: 2,
                    dashPattern: [6, 3],
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(12),
                    child: Container(
                      width: double.infinity,
                      height: 40,
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(Icons.add, color: Colors.teal),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 70),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        'Apply',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}
