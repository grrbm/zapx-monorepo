import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/repository/home_api/home_http_api_repository.dart';
import 'package:zapxx/view/nav_bar/user/home/filter/filter_screen.dart';
import 'package:zapxx/view/nav_bar/user/home/home_screen/custom_widget/date_dailog.dart';
import 'package:zapxx/view/nav_bar/user/home/home_screen/custom_widget/marker_widget.dart';
import 'package:zapxx/view/nav_bar/user/home/home_screen/location_popup.dart';
import 'package:zapxx/view/nav_bar/user/home/home_screen/post_model.dart';
import 'package:zapxx/view/nav_bar/user/home/map_slide_screen/map_slide_screen.dart';
import 'package:zapxx/view/nav_bar/user/home/services/services_screen.dart';
import "package:geolocator/geolocator.dart";
import 'package:zapxx/view/nav_bar/user/home/services/widgets/scheduler_type_model.dart';
import 'package:zapxx/view_model/services/session_manager/session_controller.dart';
import 'package:geocoding/geocoding.dart';
import 'package:widget_to_marker/widget_to_marker.dart';

GlobalKey markerKey = GlobalKey();

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, String>> servicesList = [
    {'title': 'Photography', 'image': 'assets/images/photography.png'},
    {'title': 'Videography', 'image': 'assets/images/videography.png'},
  ];
  List<Post> _posts = [];
  bool isLoading = false;
  late String selectedCategory;
  Map<String, dynamic> currentFilters = {};
  int selectedIndex = 0; // Set default to the first index
  bool isSelected = false;
  // New York as example
  LatLng? _currentLocation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initLocationAndMarkers(); // or whatever your method is
    });
  }

  Future<void> _initLocationAndMarkers() async {
    await _getUserCurrentLocation();
    await _loadMarkers();
  }

  Future<void> _getUserCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever
      return;
    }

    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });

    // Move the map to the current location
    final controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLng(_currentLocation!));

    // Fetch posts and add markers
    print(_currentLocation);
    if (_currentLocation != null) {
      _getAddressFromCoordinates(
        _currentLocation!.latitude,
        _currentLocation!.longitude,
      );
    }
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  Future<void> _onMapCreated(GoogleMapController controller) async {
    _controller.complete(controller);
    String style = await rootBundle.loadString('assets/map_style.json');
    controller.setMapStyle(style);
  }

  Future<void> moveToLocation(LatLng newLocation) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLng(newLocation));
  }

  String? _city;
  String? _country;
  Set<Marker> _markers = {};
  Future<void> _updateMapBasedOnCity(String city) async {
    try {
      // Get the latitude and longitude for the city
      List<Location> locations = await locationFromAddress(city);
      if (locations.isNotEmpty) {
        Location location = locations.first;
        LatLng cityLatLng = LatLng(location.latitude, location.longitude);

        // Move the map to the city's location
        moveToLocation(cityLatLng);

        // Optionally update _currentLocation
        setState(() {
          _currentLocation = cityLatLng;
        });

        print("City location: $cityLatLng");
      } else {
        print("No location found for city: $city");
      }
    } catch (e) {
      print("Error fetching location for city: $e");
    }
  }

  ServiceSchedulerType? _portfolioScheduler;
  ServiceSchedulerType? _timeSlotScheduler;
  ServiceSchedulerType? _reviewScheduler;
  bool _tabLoading = false;
  final String _portfolioViewType = 'PORTFOLIO';
  final String _timeSlotViewType = 'TIMESLOTS';
  final String _reviewViewType = 'REVIEWS';
  Future<void> _fetchSchedulerDetails(int id) async {
    setState(() => _tabLoading = true);
    try {
      final repository = HomeHttpApiRepository();
      final token = SessionController().authModel.response.token;
      final response = await repository.getSchedulerDetails(
        headers: {'Authorization': token},
        schedulerId: id,
        viewType: _portfolioViewType,
      );
      final responseTime = await repository.getSchedulerDetails(
        headers: {'Authorization': token},
        schedulerId: id,
        viewType: _timeSlotViewType,
      );
      final responseReview = await repository.getSchedulerDetails(
        headers: {'Authorization': token},
        schedulerId: id,
        viewType: _reviewViewType,
      );
      setState(() {
        _portfolioScheduler = response;
        _timeSlotScheduler = responseTime;
        _reviewScheduler = responseReview;
        _tabLoading = false;
      });
    } catch (e) {
      setState(() => _tabLoading = false);
      print('Error fetching scheduler details: $e');
    }
  }

  Future<void> _loadMarkers() async {
    try {
      setState(() => isLoading = true);

      HomeHttpApiRepository repository = HomeHttpApiRepository();
      final token = SessionController().authModel.response.token;

      // Check if token is valid
      if (token == null || token.isEmpty) {
        print('❌ Error: No valid token available');
        setState(() {
          _posts = [];
          isLoading = false;
        });
        return;
      }

      print(
        '🔍 Starting _loadMarkers with token: ${token.substring(0, 20)}...',
      );
      print('🔍 Current filters: $currentFilters');

      Map<String, dynamic> queryParams = {};

      // Add price filters only if they have values
      if (currentFilters['hourlyRateMin']?.isNotEmpty == true) {
        queryParams['hourlyRateMin'] = currentFilters['hourlyRateMin'];
      }
      if (currentFilters['hourlyRateMax']?.isNotEmpty == true) {
        queryParams['hourlyRateMax'] = currentFilters['hourlyRateMax'];
      }
      if (currentFilters['timeFrom']?.isNotEmpty == true) {
        print('⏰ Time from: ${currentFilters['timeFrom']}');
        queryParams['timeFrom'] = currentFilters['timeFrom'];
      }
      if (currentFilters['timeTo']?.isNotEmpty == true) {
        queryParams['timeTo'] = currentFilters['timeTo'];
        print('⏰ Time to: ${currentFilters['timeTo']}');
      }
      // Add service types only if any are selected
      if (currentFilters['venueType']?.isNotEmpty == true) {
        queryParams['venueType'] = jsonEncode((currentFilters['venueType']));
      }
      if (currentFilters['locationType']?.isNotEmpty == true) {
        queryParams['locationType'] = jsonEncode(
          (currentFilters['locationType']),
        );
      }

      print('🔍 Final query params: $queryParams');

      PostModel post = await repository.fetchPosts(
        headers: {'Authorization': token},
        queryParams: queryParams.isNotEmpty ? queryParams : null,
      );

      setState(() {
        _posts = post.posts;
        isLoading = false;
      });

      print('✅ Fetched ${post.posts.length} posts successfully');
    } catch (e) {
      setState(() => isLoading = false);
      print('Error fetching posts: $e');
      // Set empty posts list on error
      setState(() {
        _posts = [];
      });
    }

    // Clear existing markers
    _markers.clear();

    // Only create markers if there are posts
    if (_posts.isEmpty) {
      print('No posts available to create markers');
      return;
    }

    for (final post in _posts) {
      try {
        // Check if post has valid location
        if (post.location.isEmpty) {
          print("⚠️ Post ${post.id} has empty location, skipping marker");
          continue;
        }

        List<Location> locations = await locationFromAddress(post.location);
        if (locations.isEmpty) {
          print(
            "⚠️ No location found for post ${post.id} at address: ${post.location}",
          );
          continue;
        }

        // Fetch scheduler details asynchronously (don't await to avoid blocking)
        _fetchSchedulerDetails(post.seller.scheduler.id);

        final location = locations.first;
        final LatLng latLng = LatLng(location.latitude, location.longitude);
        print('📍 Created marker for post ${post.id} at: $location');

        final marker = Marker(
          onTap: () {
            // Check if scheduler data is available before showing modal
            if (_portfolioScheduler != null &&
                _timeSlotScheduler != null &&
                _reviewScheduler != null) {
              showModalBottomSheet(
                isScrollControlled: true,
                isDismissible: true,
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20.r),
                  ),
                ),
                builder:
                    (context) => MapSlideScreen(
                      portfolioScheduler: _portfolioScheduler!,
                      timeSlotScheduler: _timeSlotScheduler!,
                      reviewScheduler: _reviewScheduler!,
                    ),
              );
            } else {
              print("⚠️ Scheduler data not available for post ${post.id}");
              // Show a simple snackbar or dialog instead
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Loading details for this post...')),
              );
            }
          },
          markerId: MarkerId(post.id.toString()),
          position: latLng,
          icon: await MarkerWidget().toBitmapDescriptor(
            logicalSize: const Size(150, 150),
            imageSize: const Size(300, 300),
          ),
        );

        setState(() {
          _markers.add(marker);
        });
      } catch (e) {
        print("❌ Marker rendering failed for post ${post.id}: $e");
      }
    }
  }

  Future<void> _getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        setState(() {
          _city = place.locality;
          _country = place.country;
        });
      }
    } catch (e) {
      print("Error fetching address: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Stack(
        children: [
          _currentLocation == null
              ? const Center(
                child: CircularProgressIndicator(
                  color: AppColors.backgroundColor,
                ),
              )
              : GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _currentLocation!,
                  zoom: 14,
                ),
                mapType: MapType.normal,
                markers: _markers,
                // myLocationEnabled: true,
                myLocationButtonEnabled: true,
              ),

          Positioned(
            top: 50.w,
            left: 16.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 293.w,
                    height: 48.w,
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            final selectedCity = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => const LocationChangePopUp(),
                              ),
                            );

                            if (selectedCity != null &&
                                selectedCity is String) {
                              setState(() {
                                _city =
                                    selectedCity; // Update the city variable
                              });

                              // Update the map based on the selected city
                              // Call a method to update the map, e.g., _updateMap(selectedCity);
                              _updateMapBasedOnCity(selectedCity);
                            }
                          },
                          child: Row(
                            children: [
                              Image(
                                width: 20.w,
                                height: 20.w,
                                image: const AssetImage(
                                  'assets/images/map_pin.png',
                                ),
                              ),
                              SizedBox(width: 8.w),
                              CustomText(
                                text: _city ?? "loading, ${_country ?? "..."}",
                                fontSized: 14.0,
                                color: AppColors.blackColor,
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final filters = await showDialog(
                              context: context,
                              builder: (context) {
                                return const DateDialogBox();
                              },
                            );
                            if (filters != null) {
                              setState(() => currentFilters = filters);
                              print("test$filters");
                              await _loadMarkers();
                            }
                          },
                          child: Row(
                            children: [
                              VerticalDivider(indent: 5.w, endIndent: 5.w),
                              SizedBox(width: 5.w),
                              const CustomText(
                                text: 'When?',
                                fontSized: 14.0,
                                color: AppColors.blackColor,
                              ),
                              SizedBox(width: 30.w),
                              Image(
                                width: 24.w,
                                height: 24.w,
                                image: const AssetImage(
                                  'assets/images/search_normal.png',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                GestureDetector(
                  onTap: () async {
                    final filters = await showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20.r),
                        ),
                      ),
                      builder: (context) => const FilterScreen(),
                    );
                    print(filters);
                    if (filters.isNotEmpty) {
                      setState(() => currentFilters = filters);
                      await _loadMarkers();
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Image(
                      width: 18.w,
                      height: 18.w,
                      image: const AssetImage('assets/images/filter.png'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16.w),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                border: const Border(
                  top: BorderSide(color: AppColors.backgroundColor, width: 3.0),
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CustomText(
                    text: 'Services',
                    fontSized: 16.0,
                    fontWeight: FontWeight.w700,
                    color: AppColors.blackColor,
                  ),
                  SizedBox(height: 21.w),
                  SizedBox(
                    height: 80.w,
                    child: ListView.builder(
                      itemCount: servicesList.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(left: 16.w),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                                isSelected = true;
                              });
                            },
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => ServicesScreen(
                                          title: servicesList[index]['title']!,
                                        ),
                                  ),
                                );
                              },
                              child: serviceCard(
                                servicesList[index]['title']!,
                                servicesList[index]['image']!,
                                isSelected, // Pass the selected state
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
    );
  }

  Widget serviceCard(String serviceName, String imagePath, bool isSelected) {
    return Container(
      width: 162.w,
      height: 58.w,
      padding: EdgeInsets.symmetric(vertical: 10.w),
      decoration: BoxDecoration(
        color:
            isSelected
                ? AppColors.backgroundColor.withOpacity(0.01)
                : AppColors.whiteColor, // Change background if selected
        border: Border.all(
          color:
              isSelected
                  ? AppColors.backgroundColor.withOpacity(0.4)
                  : AppColors.greyColor.withOpacity(0.1),
          width: 1.w,
        ),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(color: AppColors.greyColor.withOpacity(0.1), blurRadius: 5),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            height: 58.w,
            width: 74.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.asset(fit: BoxFit.cover, imagePath),
            ),
          ),
          CustomText(
            text: serviceName,
            fontSized: 11.0,
            fontWeight: FontWeight.w700,
            color: AppColors.blackColor,
          ),
        ],
      ),
    );
  }
}
