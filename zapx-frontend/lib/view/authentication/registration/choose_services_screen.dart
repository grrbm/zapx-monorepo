import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_button.dart';
import 'package:zapxx/model/services_model.dart';
import 'package:zapxx/repository/home_api/home_http_api_repository.dart';
import 'package:zapxx/view/authentication/registration/verify_identity_screen.dart';
import 'package:zapxx/view/authentication/widgets/welcome_title.dart';

class ChooseServicesScreen extends StatefulWidget {
  final String service;
  const ChooseServicesScreen({super.key, required this.service});

  @override
  State<ChooseServicesScreen> createState() => _ChooseServicesScreenState();
}

class _ChooseServicesScreenState extends State<ChooseServicesScreen> {
  final List<ServiceModel> photographyServices = [];
  final List<ServiceModel> videographyServices = [];
  final List<int> selectedServiceIds = [];
  final List<int> selectedSendServiceIds = [];
  String searchText = '';

  @override
  void initState() {
    super.initState();
    fetchServices();
  }

  void fetchServices() async {
    HomeHttpApiRepository repository = HomeHttpApiRepository();
    if (widget.service == 'photography') {
      ServicesModel servicesModel = await repository.fetchPhotographyList();
      setState(() {
        photographyServices.addAll(servicesModel.services);
      });
    } else {
      ServicesModel servicesModel = await repository.fetchVideographyList();
      setState(() {
        videographyServices.addAll(servicesModel.services);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 26.w),
            WelcomeTitle(
              title: 'Choose Services',
              subTitle: widget.service == 'photography'
                  ? 'Please choose photography Services you offer'
                  : 'Please choose Videography Services you offer',
              crossAxisAlignment: CrossAxisAlignment.start,
              textAlign: TextAlign.start,
              topPadding: 36.w,
            ),
            SizedBox(height: 16.w),
            TextField(
              onChanged: (value) {
                setState(() {
                  searchText = value.toLowerCase();
                });
              },
              style: TextStyle(color: AppColors.blackColor, fontSize: 16.sp),
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.w),
                suffixIcon: Icon(Icons.search, size: 20.w),
                filled: true,
                fillColor: AppColors.whiteColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                      color: AppColors.greyColor1.withOpacity(0.3), width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                      color: AppColors.greyColor1.withOpacity(0.3), width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                      color: AppColors.greyColor1.withOpacity(0.3), width: 1),
                ),
              ),
            ),
            Expanded(
              child: widget.service == 'photography'
                  ? photographyListView()
                  : videographyListView(),
            ),
            SizedBox(height: 20.w),
            CustomButton(
              title: 'Continue',
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => VerifyIdentityScreen(
                              selectedServiceIds: selectedServiceIds,
                              categoryId:
                                  widget.service == 'photography' ? 1 : 2,
                            )));
              },
              btnColor: AppColors.backgroundColor,
              btnTextColor: AppColors.whiteColor,
            ),
            SizedBox(height: 20.w),
          ],
        ),
      ),
    );
  }

  ListView photographyListView() {
    return ListView.builder(
      itemCount: photographyServices.length,
      itemBuilder: (context, index) {
        if (photographyServices[index]
            .name
            .toLowerCase()
            .contains(searchText)) {
          return InkWell(
            splashColor: Colors.transparent,
            onTap: () {
              setState(() {
                if (selectedServiceIds
                    .contains(photographyServices[index].id)) {
                  selectedServiceIds.remove(photographyServices[index].id);
                } else {
                  selectedServiceIds.add(photographyServices[index].id);
                  print(photographyServices[index].id);
                }
              });
            },
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      photographyServices[index].name,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.black,
                      ),
                    ),
                    selectedServiceIds.contains(photographyServices[index].id)
                        ? Image.asset(
                            'assets/images/radios.png',
                            width: 20.w,
                            height: 20.w,
                          )
                        : const SizedBox(),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.w),
                  child: Divider(
                    color: AppColors.greyColor.withOpacity(0.04),
                    height: 0,
                  ),
                )
              ],
            ),
          );
        }
        return Container();
      },
    );
  }

  ListView videographyListView() {
    return ListView.builder(
      itemCount: videographyServices.length,
      itemBuilder: (context, index) {
        if (videographyServices[index]
            .name
            .toLowerCase()
            .contains(searchText)) {
          return InkWell(
            splashColor: Colors.transparent,
            onTap: () {
              setState(() {
                if (selectedServiceIds
                    .contains(videographyServices[index].id)) {
                  selectedServiceIds.remove(videographyServices[index].id);
                } else {
                  selectedServiceIds.add(videographyServices[index].id);
                }
              });
            },
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      videographyServices[index].name,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.black,
                      ),
                    ),
                    selectedServiceIds.contains(videographyServices[index].id)
                        ? Image.asset(
                            'assets/images/radios.png',
                            width: 20.w,
                            height: 20.w,
                          )
                        : const SizedBox(),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.w),
                  child: Divider(
                    color: AppColors.greyColor.withOpacity(0.04),
                    height: 0,
                  ),
                )
              ],
            ),
          );
        }
        return Container();
      },
    );
  }
}
