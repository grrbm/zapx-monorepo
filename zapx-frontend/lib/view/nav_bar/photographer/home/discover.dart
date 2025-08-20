import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_app_bar.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/view/nav_bar/photographer/home/creating_post/creating_post.dart';
import 'package:zapxx/view/nav_bar/user/home/home_screen/custom_widget/marker_widget.dart';
import 'package:http/http.dart' as http;
import 'package:widget_to_marker/widget_to_marker.dart';
import 'package:intl/intl.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key, required this.currentLocation});
  final LatLng currentLocation;
  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  // Categories for filtering
  final List<String> categories = [
    'All',
    'Studios',
    'Rooftops',
    'Parks',
    'Concerts',
    'Beaches',
    'Warehouses',
    'Train Tracks',
    'Parking Garages',
    'Abandoned Buildings',
    'Theaters',
    'Sports Courts',
    'Pools',
    'Scenic Overlooks',
    'Light Installations',
    'Boat Docks',
    'City Skylines',
    'Churches/Cathedrals',
    'Fountains',
    'Bridges',
    'Street Art',
    'Museums',
    'Libraries',
    'Zoos/Aquariums',
  ];

  String selectedCategory = 'All';
  bool _showAllCategories = false;
  int _collapsedCount = 4;
  late LatLng _currentLocation;
  List<Map<String, String>> servicesList = [
    {
      'title': 'Westfield Coffee Shop',
      'image': 'assets/images/photography.png',
      'subtitle': 'Address: 12 Street Ontario, Canada',
    },
  ];
  Future<String?> _getPhotoUrl(String placeId) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['result'] != null &&
          data['result']['photos'] != null &&
          data['result']['photos'].isNotEmpty) {
        final photoReference = data['result']['photos'][0]['photo_reference'];
        return 'https://maps.googleapis.com/maps/api/place/photo'
            '?maxwidth=400&photoreference=$photoReference&key=$apiKey';
      }
    }
    return null;
  }

  void _onMarkerTapped(Map<String, dynamic> place) async {
    final photoUrl = await _getPhotoUrl(place['place_id']);
    print((photoUrl));
    setState(() {
      selectedPlace = {
        'name': place['name'],
        'vicinity': place['vicinity'],
        'photoUrl': photoUrl,
      };
    });
  }

  int selectedIndex = 0; // Set default to the first index
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  Future<void> _onMapCreated(GoogleMapController controller) async {
    _controller.complete(controller);
    String style = await rootBundle.loadString('assets/map_style.json');
    controller.setMapStyle(style);
  }

  Map<String, dynamic>? selectedPlace;
  List<Marker> _markers = [];
  String apiKey = 'AIzaSyDPWS2vmzCMsIJhynHs1ugynhXRd9na-zU';
  Future<void> _fetchNearbyPlaces({List<String>? categories}) async {
    // Build keyword from multiple categories
    String keyword = '';
    if (categories != null && categories.isNotEmpty) {
      if (categories.contains('All')) {
        keyword = ''; // No filter when "All" is selected
      } else {
        // Combine multiple categories with OR logic
        keyword = categories.map((cat) => cat.toLowerCase()).join('|');
      }
    }

    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
      '?location=${_currentLocation.latitude},${_currentLocation.longitude}'
      '&radius=50000&type=point_of_interest'
      '&keyword=$keyword'
      '&key=$apiKey',
    );

    final response = await http.get(url);
    print(response.body);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['results'] != null) {
        final List places = data['results'];

        // Prepare a list of markers asynchronously
        List<Marker> markers = [];
        for (var place in places) {
          final location = place['geometry']['location'];
          final icon = await MarkerWidget().toBitmapDescriptor(
            logicalSize: const Size(150, 150),
            imageSize: const Size(300, 300),
          );

          markers.add(
            Marker(
              onTap: () => _onMarkerTapped(place),
              markerId: MarkerId(place['place_id']),
              position: LatLng(location['lat'], location['lng']),
              infoWindow: InfoWindow(
                title: place['name'],
                snippet: place['vicinity'],
              ),
              icon: icon,
            ),
          );
        }

        // Update state with the prepared markers
        setState(() {
          _markers = markers;
        });
      }
    } else {
      print('Failed to fetch nearby places: ${response.body}');
    }
  }

  void _onCategorySelected(String category) {
    setState(() {
      if (category == 'All') {
        // If "All" is selected, clear other selections
        selectedCategory = 'All';
      } else {
        // Remove "All" if it was selected
        selectedCategory = category;
      }

      _markers.clear(); // Clear existing markers
    });

    // Fetch markers based on selected categories
    _fetchNearbyPlaces(categories: [selectedCategory]);
  }

  void _onCameraIdle() async {
    final GoogleMapController controller = await _controller.future;
    final LatLngBounds bounds = await controller.getVisibleRegion();
    final LatLng center = LatLng(
      (bounds.northeast.latitude + bounds.southwest.latitude) / 2,
      (bounds.northeast.longitude + bounds.southwest.longitude) / 2,
    );

    setState(() {
      _currentLocation = center; // Update map center location
    });

    _fetchNearbyPlaces(categories: [selectedCategory]); // Fetch new locations
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentLocation = widget.currentLocation;
    _fetchNearbyPlaces(categories: [selectedCategory]);
  }

  Widget _buildCategorySelector() {
    if (!_showAllCategories) {
      // Collapsed: horizontal chips
      final visibleCategories = categories.take(_collapsedCount).toList();
      return SizedBox(
        height: 48,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            ...visibleCategories.map(
              (category) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ChoiceChip(
                  backgroundColor: AppColors.whiteColor,
                  label: CustomText(
                    text: category,
                    fontSized: 12.0,
                    fontWeight: FontWeight.bold,
                  ),
                  selected: selectedCategory == category,
                  onSelected: (_) => _onCategorySelected(category),
                  selectedColor: AppColors.backgroundColor,
                  labelStyle: TextStyle(
                    color:
                        selectedCategory == category
                            ? Colors.white
                            : Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: ActionChip(
                backgroundColor: AppColors.whiteColor,
                label: CustomText(
                  text: 'View All',
                  fontSized: 12.0,
                  fontWeight: FontWeight.bold,
                ),
                onPressed: () {
                  setState(() {
                    _showAllCategories = true;
                  });
                },
              ),
            ),
          ],
        ),
      );
    } else {
      // Expanded: vertical animated list
      final double itemHeight = 48.0;
      final double maxHeight = MediaQuery.of(context).size.height * 0.5;
      return AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        constraints: BoxConstraints(
          maxHeight: maxHeight,
          minHeight: (_collapsedCount * itemHeight) + 48,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with close button
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.backgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Category',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _showAllCategories = false;
                      });
                    },
                    icon: Icon(Icons.close, color: AppColors.whiteColor),
                    iconSize: 20,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = selectedCategory == category;
                  return ListTile(
                    leading: Icon(
                      isSelected ? Icons.check_circle : Icons.circle_outlined,
                      color:
                          isSelected ? AppColors.backgroundColor : Colors.grey,
                    ),
                    title: Text(
                      category,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color:
                            isSelected
                                ? AppColors.backgroundColor
                                : Colors.black,
                      ),
                    ),
                    tileColor:
                        isSelected
                            ? AppColors.backgroundColor.withOpacity(0.08)
                            : null,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onTap: () => _onCategorySelected(category),
                  );
                },
                separatorBuilder:
                    (context, index) =>
                        Divider(height: 1, color: Colors.grey[200]),
              ),
            ),
            // Footer with action buttons
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        selectedCategory = 'All';
                        _showAllCategories = false;
                      });
                      _fetchNearbyPlaces(categories: [selectedCategory]);
                    },
                    child: CustomText(
                      text: 'Clear All',
                      color: AppColors.redColor,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _showAllCategories = false;
                      });
                    },
                    child: CustomText(
                      text: 'Done',
                      color: AppColors.backgroundColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Discover',
        backgroundColor: AppColors.whiteColor,
      ),
      backgroundColor: AppColors.whiteColor,
      body: Stack(
        children: [
          Stack(
            children: [
              GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _currentLocation,
                  zoom: 14,
                ),
                mapType: MapType.normal,
                onCameraIdle: _onCameraIdle,
                markers: Set<Marker>.of(_markers),
                myLocationButtonEnabled: false,
              ),
              // Use the new animated vertical category list
              Positioned(
                top: 20.w,
                left: 8.w,
                right: 8.w,
                child: _buildCategorySelector(),
              ),
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 21.w),
                      SizedBox(
                        height: 270.w,
                        child: ListView.builder(
                          itemCount: servicesList.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(left: 48.w),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedIndex = index;
                                  });
                                },
                                child: GestureDetector(
                                  onTap: () {},
                                  child: serviceCard(
                                    selectedPlace?['name'] ??
                                        servicesList[index]['title']!,
                                    selectedPlace?['photoUrl'] ?? "no",
                                    selectedPlace?['vicinity'] ??
                                        servicesList[index]['subtitle']!,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget serviceCard(String serviceName, String imagePath, String subtitle) {
    return Container(
      width: 282.w,
      height: 308.w,
      padding: EdgeInsets.symmetric(vertical: 10.w),
      decoration: BoxDecoration(
        color: AppColors.whiteColor, // Change background if selected
        border: Border.all(color: AppColors.whiteColor, width: 1.w),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(color: AppColors.greyColor.withOpacity(0.1), blurRadius: 5),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ImageSlideshow(
                  width: double.infinity,
                  height: 148.w,
                  initialPage: 0,
                  indicatorColor: AppColors.backgroundColor,
                  indicatorBackgroundColor: Colors.white,
                  onPageChanged: (value) {
                    print('Page changed: $value');
                  },
                  autoPlayInterval: 000,
                  isLoop: true,
                  children: [
                    imagePath != 'no'
                        ? Image.network(
                          imagePath,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                color: AppColors.backgroundColor,
                                value:
                                    loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            (loadingProgress
                                                    .expectedTotalBytes ??
                                                1)
                                        : null,
                              ),
                            );
                          },
                        )
                        : Image.asset(
                          'assets/images/photography.png',
                          fit: BoxFit.cover,
                        ),
                  ],
                ),

                Positioned(
                  top: 10.h,
                  left: 20.w,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.backgroundColor,
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.w,
                        vertical: 4.h,
                      ),
                      child: CustomText(
                        text: DateFormat('EEEE').format(DateTime.now()),
                        fontSized: 8.sp,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.w),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: serviceName,
                    fontSized: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.blackColor,
                  ),
                  SizedBox(height: 5.h),
                  CustomText(
                    text: subtitle,
                    fontSized: 12.sp,
                    color: AppColors.blackColor,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 5.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text:
                            '${DateFormat('h:mm a').format(DateTime.now())} - ${DateFormat('h:mm a').format(DateTime.now().add(Duration(hours: 1)))}',
                        fontSized: 12.sp,
                        color: AppColors.backgroundColor,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      CreatingPost(locationAddress: subtitle),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 4.w,
                            horizontal: 10.w,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.backgroundColor.withOpacity(.12),
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 3.h,
                            ),
                            child: CustomText(
                              text: 'Post',
                              fontSized: 12.sp,
                              color: AppColors.backgroundColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
