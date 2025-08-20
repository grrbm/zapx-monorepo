import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_app_bar.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/repository/home_api/home_http_api_repository.dart';
import 'package:zapxx/view/nav_bar/user/home/services/services_scheduler.dart';
import 'package:zapxx/view/nav_bar/user/home/services/widgets/filter_screen.dart';
import 'package:zapxx/view/nav_bar/user/home/services/widgets/photography_listview_widget.dart';
import 'package:zapxx/view/nav_bar/user/home/services/widgets/search_widget.dart';
import 'package:zapxx/view/nav_bar/user/home/services/widgets/videography_listview_widget.dart';
import 'package:zapxx/view_model/services/session_manager/session_controller.dart';

class ServicesScreen extends StatefulWidget {
  String title;
  ServicesScreen({super.key, required this.title});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  List<ServiceScheduler> serviceSchedulers = [];
  bool isLoading = false;
  late String selectedCategory;
  Map<String, dynamic> currentFilters = {};
  @override
  void initState() {
    super.initState();
    selectedCategory = widget.title;
    fetchServices();
  }

  void fetchServices() async {
    try {
      setState(() => isLoading = true);
      HomeHttpApiRepository repository = HomeHttpApiRepository();
      final token = SessionController().authModel.response.token;

      Map<String, dynamic> queryParams = {};

      // Always set the categoryId based on the selected category
      queryParams['categoryId'] = selectedCategory == 'Photography' ? 1 : 2;

      // Add price filters only if they have values
      if (currentFilters['minimumRate']?.isNotEmpty == true) {
        queryParams['minimumRate'] = currentFilters['minimumRate'];
      }
      if (currentFilters['maximumRate']?.isNotEmpty == true) {
        queryParams['maximumRate'] = currentFilters['maximumRate'];
      }

      // Add service types only if any are selected
      if (currentFilters['serviceType']?.isNotEmpty == true) {
        final serviceTypes = currentFilters['serviceType'] as List<int>;
        queryParams['serviceType'] = jsonEncode(
          serviceTypes.map((id) => {'id': id}).toList(),
        );
      }

      ApiResponseScheduler scheduler = await repository.fetchServiceScheduler(
        headers: {'Authorization': token},
        queryParams: queryParams.isNotEmpty ? queryParams : null,
      );

      setState(() {
        serviceSchedulers = scheduler.serviceScheduler;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      print('Error fetching services: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(title: widget.title),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: Divider(
                color: AppColors.greyColor.withOpacity(
                  0.4,
                ), // Use your border color
                thickness: 1,
                height: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.w),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CustomText(
                            text:
                                selectedCategory == 'Photography'
                                    ? 'Photographer'
                                    : 'Videographer',
                            fontSized: 16.0,
                            fontWeight: FontWeight.w700,
                            color: AppColors.blackColor,
                          ),
                          SizedBox(width: 4.w),
                          PopupMenuButton(
                            color: AppColors.whiteColor,
                            icon: Image.asset(
                              'assets/images/arrow_down.png',
                              width: 18.w,
                              height: 18.w,
                            ),
                            onSelected: (value) {
                              setState(() {
                                selectedCategory = value;
                                // Clear filters when switching categories
                                currentFilters = {};
                              });
                              fetchServices();
                            },
                            itemBuilder:
                                (context) => [
                                  PopupMenuItem(
                                    value: 'Videography',
                                    child: Center(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.backgroundColor,
                                          borderRadius: BorderRadius.circular(
                                            7.r,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8.w,
                                            vertical: 6.w,
                                          ),
                                          child: CustomText(
                                            text: 'Videographers',
                                            fontSized: 16.w,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.whiteColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 'Photography',
                                    child: Center(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.backgroundColor,
                                          borderRadius: BorderRadius.circular(
                                            7.r,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8.w,
                                            vertical: 6.w,
                                          ),
                                          child: CustomText(
                                            text: 'Photographers',
                                            fontSized: 16.w,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.whiteColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                          ),
                        ],
                      ),
                      Stack(
                        children: [
                          Tooltip(
                            message:
                                currentFilters.isNotEmpty
                                    ? 'Clear filters'
                                    : 'Filter options',
                            child: GestureDetector(
                              onTap: () async {
                                if (currentFilters.isNotEmpty) {
                                  // If filters are active, clear them
                                  setState(() => currentFilters = {});
                                  fetchServices();
                                  // Show feedback to user
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Filters cleared'),
                                      duration: Duration(seconds: 1),
                                      backgroundColor:
                                          AppColors.backgroundColor,
                                    ),
                                  );
                                } else {
                                  // If no filters, open filter screen
                                  final filters = await showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20.r),
                                      ),
                                    ),
                                    builder:
                                        (context) => ServicesFilterScreen(
                                          currentCategory: selectedCategory,
                                        ),
                                  );

                                  if (filters != null) {
                                    if (filters.isEmpty) {
                                      // Clear all filters
                                      setState(() => currentFilters = {});
                                    } else {
                                      // Apply new filters
                                      setState(() => currentFilters = filters);
                                    }
                                    fetchServices();
                                    // Show feedback to user
                                    if (filters.isNotEmpty) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text('Filters applied'),
                                          duration: Duration(seconds: 1),
                                          backgroundColor:
                                              AppColors.backgroundColor,
                                        ),
                                      );
                                    }
                                  }
                                }
                              },
                              child: Container(
                                width: 42.w,
                                height: 42.w,
                                decoration: BoxDecoration(
                                  color:
                                      currentFilters.isNotEmpty
                                          ? AppColors.backgroundColor
                                              .withOpacity(0.1)
                                          : AppColors.whiteColor,
                                  borderRadius: BorderRadius.circular(16.r),
                                  border: Border.all(
                                    color:
                                        currentFilters.isNotEmpty
                                            ? AppColors.backgroundColor
                                            : AppColors.greyColor.withOpacity(
                                              0.4,
                                            ),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(12.w),
                                  child: Image(
                                    color:
                                        currentFilters.isNotEmpty
                                            ? AppColors.backgroundColor
                                            : AppColors.greyColor.withOpacity(
                                              0.6,
                                            ),
                                    image: AssetImage(
                                      currentFilters.isNotEmpty
                                          ? 'assets/images/cancel.png'
                                          : 'assets/images/filter.png',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 14.w),
                  isLoading
                      ? CircularProgressIndicator()
                      : serviceSchedulers.isEmpty
                      ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 50.w,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16.w),
                          Text(
                            'No results found\nTry adjusting your filters',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16.w,
                              color: Colors.grey,
                            ),
                          ),
                          if (currentFilters.isNotEmpty)
                            TextButton(
                              onPressed: () {
                                setState(() => currentFilters = {});
                                fetchServices();
                              },
                              child: Text('Clear Filters'),
                            ),
                        ],
                      )
                      : selectedCategory == 'Photography'
                      ? PhotographyListview(services: serviceSchedulers)
                      : VideographyListviewWidget(services: serviceSchedulers),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
