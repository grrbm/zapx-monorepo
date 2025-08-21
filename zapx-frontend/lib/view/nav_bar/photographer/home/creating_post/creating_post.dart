import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' as getX;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/configs/utils.dart';
import 'package:zapxx/controller/post_controller.dart';
import 'package:zapxx/view/nav_bar/photographer/home/creating_post/category_screen.dart';
import 'package:zapxx/view/nav_bar/photographer/home/creating_post/post_time_widget.dart';
import '../../../../../configs/app_url.dart';
import '../../../../../view_model/services/session_manager/session_controller.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_button.dart';

class CreatingPost extends StatefulWidget {
  const CreatingPost({super.key, required this.locationAddress});
  final String? locationAddress;

  @override
  State<CreatingPost> createState() => _CreatingPostState();
}

class _CreatingPostState extends State<CreatingPost> {
  TextEditingController locationAddressCtrl = TextEditingController();
  TextEditingController descriptionCtrl = TextEditingController();
  TextEditingController additionalNotesCtrl = TextEditingController();
  TextEditingController hourlyRateCtrl = TextEditingController();
  List<File> _selectedImages = [];
  Duration duration = const Duration(hours: 1, minutes: 23);
  Duration firstDuration = const Duration(hours: 1, minutes: 23);
  bool _isLoading = false;
  // Function to pick multiple images
  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();

    if (pickedFiles != null) {
      setState(() {
        _selectedImages.addAll(pickedFiles.map((file) => File(file.path)));
      });
    }
  }

  // Function to remove an image from the list
  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? "AM" : "PM";
    return "$hour:$minute $period";
  }

  List<Map<String, TimeOfDay>> timeRanges = [];

  // Method to convert time ranges into the desired API format
  List<Map<String, String>> getApiFormattedTimeRanges(
    List<Map<String, TimeOfDay>> timeRanges,
    DateTime selectedDate,
  ) {
    return timeRanges.map((range) {
      final startTime = _convertToDateTime(range['start']!, selectedDate);
      final endTime = _convertToDateTime(range['end']!, selectedDate);

      return {
        "startTime": startTime.toUtc().toIso8601String(),
        "endTime": endTime.toUtc().toIso8601String(),
      };
    }).toList();
  }

  // Helper method to convert TimeOfDay to DateTime
  DateTime _convertToDateTime(TimeOfDay time, DateTime selectedDate) {
    return DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      time.hour,
      time.minute,
    );
  }

  void stopProgress() {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _uploadPost() async {
    try {
      // Validate required fields before sending
      if (locationAddressCtrl.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location is required')),
        );
        return;
      }
      
      if (descriptionCtrl.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Description is required')),
        );
        return;
      }
      
      if (hourlyRateCtrl.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Hourly rate is required')),
        );
        return;
      }
      
      if (_selectedImages.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('At least one image is required')),
        );
        return;
      }
      
      if (timeRanges.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('At least one time slot is required')),
        );
        return;
      }

      final dio = Dio(BaseOptions(baseUrl: AppUrl.baseUrl));
      final token = SessionController().authModel.response.token;
      
      if (token.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Authentication token missing. Please login again.')),
        );
        return;
      }
      
      setState(() {
        _isLoading = true;
      });

      List<Map<String, dynamic>> selectedVenuesJson =
          getX.Get.find<PostController>().selectedVenues
              .map((venue) => {"id": venue.id})
              .toList();
      List<Map<String, dynamic>> selectedLocationJson =
          getX.Get.find<PostController>().selectedLocations
              .map((location) => {"id": location.id})
              .toList();
      
      // Validate that at least one venue or location type is selected
      if (selectedVenuesJson.isEmpty && selectedLocationJson.isEmpty) {
        stopProgress();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one venue type or location type')),
        );
        return;
      }
      
      final formData = FormData();

      // Add images to FormData
      for (var image in _selectedImages) {
        formData.files.addAll([
          MapEntry(
            'image',
            await MultipartFile.fromFile(
              image.path,
              filename: image.path.split('/').last,
              contentType: MediaType('image', 'jpeg'),
            ),
          ),
        ]);
      }
      final apiPayload = getApiFormattedTimeRanges(timeRanges, DateTime.now());
      // Use 'apiPayload' in your API request body.

      // Add fields to FormData
      formData.fields.addAll([
        MapEntry(
          'Time',
          jsonEncode(apiPayload),
          // '[{"startTime":"$firstDuration","endTime":"$duration"}]',
        ),
        MapEntry('notes', additionalNotesCtrl.text),
        MapEntry('description', descriptionCtrl.text),
        MapEntry('hourlyRate', hourlyRateCtrl.text),
        MapEntry('location', locationAddressCtrl.text),
        MapEntry('LocationType', jsonEncode(selectedLocationJson)),
        MapEntry('VenueType', jsonEncode(selectedVenuesJson)),
      ]);
      print(formData.fields);
      logger.i(formData.fields);
      final response = await dio.post(
        AppUrl.postOnMap, // Replace with your API endpoint
        data: formData,
        options: Options(
          headers: {'Authorization': token, 'Accept': 'application/json'},
          contentType: 'multipart/form-data',
        ),
      );

      if (response.statusCode == 200) {
        logger.i(response.data);
        setState(() {
          _isLoading = false;
        });
        getX.Get.back();
        Utils.flushBarSuccessMessage('Post uploaded successfully!', context);
        setState(() {
          _selectedImages.clear();
        });
        getX.Get.find<PostController>().selectedVenues.clear();
        getX.Get.find<PostController>().selectedLocations.clear();
        getX.Get.find<PostController>().locationTypeCtrl.clear();
        getX.Get.find<PostController>().venueTypeCtrl.clear();
        getX.Get.find<PostController>().update();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Upload failed. Please try again.')),
        );
      }
    } on DioException catch (e) {
      stopProgress();
      print('Upload error: ${e.response?.data}');
      
      String errorMessage = 'Upload failed';
      if (e.response?.data is Map<String, dynamic>) {
        errorMessage = e.response?.data['message'] ?? 'Upload failed';
      } else if (e.response?.data is String) {
        errorMessage = 'Server error occurred';
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      stopProgress();
      print('General error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Upload failed: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showDialog(Widget child) {
    showDialog<void>(
      context: context,
      builder:
          (BuildContext context) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 216, width: 300, child: child),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text('OK'),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: .2,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Creating Post',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: getX.GetBuilder<PostController>(
        builder: (PostController postCtrl) {
          locationAddressCtrl.text =
              widget.locationAddress == ''
                  ? locationAddressCtrl.text
                  : widget.locationAddress!;
          return Center(
            child: SizedBox(
              width: double.infinity,
              // color: Colors.amber,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      CustomText(
                        text: "Location's address",
                        fontSized: 16.sp,
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.w700,
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.withOpacity(0.01),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: .51,
                              blurRadius: .51,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: TextField(
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                          controller: locationAddressCtrl,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            hintText: "Enter location's address",
                            hintStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      CustomText(
                        text: "Description",
                        fontSized: 16.sp,
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.withOpacity(0.01),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: .51,
                              blurRadius: .51,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: TextField(
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                          controller: descriptionCtrl,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            hintText: "Enter description",
                            hintStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      CustomText(
                        text: "Additional Notes",
                        fontSized: 16.sp,
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.withOpacity(0.02),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: .51,
                              blurRadius: .51,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: TextField(
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                          controller: additionalNotesCtrl,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            hintText: "Enter additional notes",
                            hintStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                text: "Set a time",
                                fontSized: 16.sp,
                                color: AppColors.blackColor,
                                fontWeight: FontWeight.w600,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return PostTimePicker(
                                        onTimeSelected: (timeRange) {
                                          setState(() {
                                            timeRanges.add(timeRange);
                                          });
                                          // Handle the selected time range here
                                        },
                                      );
                                    },
                                  );

                                  print(timeRanges);
                                },
                                child: Icon(
                                  Icons.add,
                                  size: 25,
                                  color: Colors.teal,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          if (timeRanges.isNotEmpty)
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: timeRanges.length,
                              itemBuilder: (context, index) {
                                final range = timeRanges[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 5,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: ListTile(
                                      title: Text(
                                        "${_formatTime(range['start']!)} - ${_formatTime(range['end']!)}",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      trailing: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            timeRanges.removeAt(index);
                                          });
                                        },
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          if (timeRanges.isEmpty)
                            Column(
                              children: [
                                Text(
                                  "No time ranges added yet.",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                                SizedBox(height: 20),
                              ],
                            ),
                        ],
                      ),
                      CustomText(
                        text: "Categorize",
                        fontSized: 16.sp,
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.w600,
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.teal),
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Display selected venues dynamically
                              Expanded(
                                child: Text(
                                  postCtrl.getSelectedNames(), // Function call
                                  // postCtrl.selectedVenues.isNotEmpty
                                  //     ? postCtrl.selectedVenues
                                  //         .map((venue) => venue.name)
                                  //         .join(", ")
                                  //     : "Select Venue", // Show placeholder if none selected
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow:
                                      TextOverflow
                                          .ellipsis, // Prevent overflow issues
                                  maxLines: 1, // Keep it single-line
                                ),
                              ),

                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.teal),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => const CategoryScreen(),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Image.asset(
                                      'assets/images/filter.png',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 10),
                      Text(
                        "Put Rate/hr",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.teal),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.withOpacity(0.2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: .51,
                              blurRadius: .51,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: TextField(
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                          controller: hourlyRateCtrl,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            hintText: "\$50",
                            hintStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Add Pictures",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: _pickImages,
                            child: DottedBorder(
                              color: Colors.grey,
                              strokeWidth: 2,
                              dashPattern: [6, 3],
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(12),
                              child: Container(
                                width: 80,
                                height: 80,
                                color: Colors.grey[200],
                                child: const Center(
                                  child: Icon(Icons.add, color: Colors.teal),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: SizedBox(
                              height: 80,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _selectedImages.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          child: Image.file(
                                            _selectedImages[index],
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 5,
                                          right: 10,
                                          child: GestureDetector(
                                            onTap: () => _removeImage(index),
                                            child: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      CustomButton(
                        loading: _isLoading,
                        title: 'Post',
                        onPressed: () {
                          if (locationAddressCtrl.text.isEmpty) {
                            Utils.flushBarErrorMessage(
                              'Please enter location address',
                              context,
                            );
                          } else if (descriptionCtrl.text.isEmpty) {
                            Utils.flushBarErrorMessage(
                              'Please enter description',
                              context,
                            );
                          } else if (additionalNotesCtrl.text.isEmpty) {
                            Utils.flushBarErrorMessage(
                              'Please enter additional notes',
                              context,
                            );
                          } else if (hourlyRateCtrl.text.isEmpty) {
                            Utils.flushBarErrorMessage(
                              'Please enter hourly rate',
                              context,
                            );
                          } else if (_selectedImages.isEmpty) {
                            Utils.flushBarErrorMessage(
                              'Please select at least one image',
                              context,
                            );
                          } else if (postCtrl.selectedVenues.isEmpty) {
                            Utils.flushBarErrorMessage(
                              'Please select a category',
                              context,
                            );
                          } else if (timeRanges.isEmpty) {
                            Utils.flushBarErrorMessage(
                              'Please select a time range',
                              context,
                            );
                          } else {
                            print(
                              postCtrl.selectedVenues.map((venue) => venue.id),
                            );
                            print(
                              postCtrl.selectedLocations.map(
                                (location) => location.id,
                              ),
                            );
                            print(postCtrl.locationTypeCtrl);
                            _uploadPost();
                          }
                        },
                        btnColor: AppColors.backgroundColor,
                        btnTextColor: AppColors.whiteColor,
                      ),

                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
