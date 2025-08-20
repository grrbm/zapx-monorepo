import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_button.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/model/services_model.dart';
import 'package:zapxx/repository/home_api/home_http_api_repository.dart';
import 'package:zapxx/view/nav_bar/user/home/filter/widgets/new_radio_item.dart';

class ServicesFilterScreen extends StatefulWidget {
  final String currentCategory;
  const ServicesFilterScreen({super.key, required this.currentCategory});

  @override
  State<ServicesFilterScreen> createState() => _ServicesFilterScreenState();
}

class _ServicesFilterScreenState extends State<ServicesFilterScreen> {
  List<int> selectedServiceIds = [];
  late bool isPhotographer;
  final List<ServiceModel> videoServices = [];
  final List<ServiceModel> photoServices = [];
  bool isLoadingVideo = true;
  bool isLoadingPhoto = true;
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isPhotographer = widget.currentCategory == 'Photography';
    _fetchServices();
  }

  void _fetchServices() {
    fetchVideoServices();
    fetchPhotoServices();
  }

  void fetchVideoServices() async {
    try {
      HomeHttpApiRepository repository = HomeHttpApiRepository();
      ServicesModel servicesModel = await repository.fetchVideographyList();
      setState(() {
        videoServices.addAll(servicesModel.services);
        isLoadingVideo = false;
      });
    } catch (e) {
      print("Error fetching video services: $e");
      setState(() => isLoadingVideo = false);
    }
  }

  void fetchPhotoServices() async {
    try {
      HomeHttpApiRepository repository = HomeHttpApiRepository();
      ServicesModel servicesModel = await repository.fetchPhotographyList();
      setState(() {
        photoServices.addAll(servicesModel.services);
        isLoadingPhoto = false;
      });
    } catch (e) {
      print("Error fetching photo services: $e");
      setState(() => isLoadingPhoto = false);
    }
  }

  bool get _hasActiveFilters {
    return _minPriceController.text.isNotEmpty ||
        _maxPriceController.text.isNotEmpty ||
        selectedServiceIds.isNotEmpty;
  }

  void _applyFilters() {
    final filters = {
      if (_minPriceController.text.isNotEmpty)
        'minimumRate': _minPriceController.text,
      if (_maxPriceController.text.isNotEmpty)
        'maximumRate': _maxPriceController.text,
      if (selectedServiceIds.isNotEmpty) 'serviceType': selectedServiceIds,
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
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.r),
                    topRight: Radius.circular(16.r),
                  ),
                ),
                child: ListView(
                  children: [
                    _buildHeader(),
                    _buildCategorySection(),
                    _buildPriceSection(),
                    _buildApplyButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.only(left: 23.w, right: 23.w, top: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CustomText(
            text: 'Filter',
            fontSized: 16.0,
            fontWeight: FontWeight.w700,
            color: AppColors.blackColor,
          ),
          Row(
            children: [
              if (_hasActiveFilters)
                TextButton(
                  onPressed: () {
                    _minPriceController.clear();
                    _maxPriceController.clear();
                    setState(() => selectedServiceIds.clear());
                  },
                  child: Text(
                    'Clear All',
                    style: TextStyle(
                      color: AppColors.backgroundColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.black45),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 23.w),
          child: Row(
            children: [
              const CustomText(
                text: 'Category',
                fontSized: 16.0,
                fontWeight: FontWeight.w600,
                color: AppColors.blackColor,
                alignment: TextAlign.start,
              ),
              if (selectedServiceIds.isNotEmpty)
                Container(
                  margin: EdgeInsets.only(left: 8.w),
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.w),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    '${selectedServiceIds.length} selected',
                    style: TextStyle(
                      color: AppColors.whiteColor,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        _buildServicesGrid(),
        SizedBox(height: 20.h),
      ],
    );
  }

  Widget _buildServicesGrid() {
    final isLoading = isPhotographer ? isLoadingPhoto : isLoadingVideo;
    final services = isPhotographer ? photoServices : videoServices;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (services.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('No services available'),
      );
    }

    return GridView.count(
      padding: EdgeInsets.only(left: 10.w, right: 10.w),
      crossAxisCount: 2,
      shrinkWrap: true,
      crossAxisSpacing: 10.w,
      childAspectRatio: 5.5,
      physics: const NeverScrollableScrollPhysics(),
      children:
          services.map((service) {
            return RadioItemNew(
              title: service.name,
              value: service.id.toString(),
              groupValues:
                  selectedServiceIds.map((id) => id.toString()).toList(),
              onChanged:
                  (value) => setState(() {
                    final intId = int.parse(value!);
                    if (selectedServiceIds.contains(intId)) {
                      selectedServiceIds.remove(intId);
                    } else {
                      selectedServiceIds.add(intId);
                    }
                  }),
            );
          }).toList(),
    );
  }

  Widget _buildPriceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 23.w),
          child: Row(
            children: [
              const CustomText(
                text: 'Price',
                fontSized: 16.0,
                fontWeight: FontWeight.w600,
                color: AppColors.blackColor,
                alignment: TextAlign.start,
              ),
              if (_minPriceController.text.isNotEmpty ||
                  _maxPriceController.text.isNotEmpty)
                Container(
                  margin: EdgeInsets.only(left: 8.w),
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.w),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    'Active',
                    style: TextStyle(
                      color: AppColors.whiteColor,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: 10.w),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildPriceField(_minPriceController, 'Lowest'),
              SizedBox(width: 10.w),
              _buildPriceField(_maxPriceController, 'Highest'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceField(TextEditingController controller, String hint) {
    return SizedBox(
      width: 155.w,
      height: 45.w,
      child: TextFormField(
        controller: controller,
        style: TextStyle(color: AppColors.blackColor),
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 16.w, top: 12.w, bottom: 12.w),
            child: const Image(
              color: AppColors.blackColor,
              image: AssetImage('assets/images/dollor.png'),
            ),
          ),
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.greyColor.withOpacity(0.4),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(color: Colors.grey),
          ),
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }

  Widget _buildApplyButton() {
    return Padding(
      padding: EdgeInsets.all(24.w),
      child: CustomButton(
        title: 'Apply',
        onPressed: _applyFilters,
        btnColor: AppColors.backgroundColor,
        btnTextColor: AppColors.whiteColor,
      ),
    );
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }
}
