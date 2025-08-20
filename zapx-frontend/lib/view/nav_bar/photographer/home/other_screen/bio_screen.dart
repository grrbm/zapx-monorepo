import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:zapxx/configs/app_url.dart';
import 'package:zapxx/configs/utils.dart';
import 'package:zapxx/view/nav_bar/photographer/home/business_builder/business_builder.dart';
import 'package:zapxx/view/nav_bar/photographer/home/other_screen/custom_widgets/custom_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:zapxx/view_model/services/session_manager/session_controller.dart';

class BioScreen extends StatefulWidget {
  const BioScreen({super.key});

  @override
  State<BioScreen> createState() => _BioScreenState();
}

class _BioScreenState extends State<BioScreen> {
  final _meController = TextEditingController();
  final _cityController = TextEditingController();
  File? _image;
  final picker = ImagePicker();
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  bool _isLoading = false;
  Future<String> _uploadImage() async {
    if (_image == null) {
      Utils.flushBarErrorMessage('Profile image required', context);
      return 'failed';
    }

    try {
      final dio = Dio(BaseOptions(baseUrl: AppUrl.baseUrl));
      final token = SessionController().authModel.response.token;
      setState(() {
        _isLoading = true;
      });
      final formData = FormData();

      formData.files.addAll([
        MapEntry(
          'image',
          await MultipartFile.fromFile(
            _image!.path,
            filename: _image!.path.split('/').last,
            contentType: MediaType('image', 'jpeg'),
          ),
        ),
      ]);

      formData.fields.addAll([
        MapEntry('aboutMe', _meController.text),
        MapEntry('location', _cityController.text),
      ]);

      print('FormData: ${formData.fields}');
      print('Files: ${formData.files}');

      final response = await dio.post(
        AppUrl.sellerBio,
        data: formData,
        options: Options(
          headers: {'Authorization': token, 'Accept': 'application/json'},
          contentType: 'multipart/form-data',
        ),
      );

      print('Upload response: ${response.data}');
      if (response.statusCode == 200) {
        setState(() {
          _isLoading = false;
        });
        return 'success';
      } else {
        return 'failed';
      }
    } on DioException catch (e) {
      print('Upload error: ${e.response?.data}');
      Utils.flushBarErrorMessage(
        e.response?.data['message'] ?? 'Upload failed',
        context,
      );
      return 'failed';
    } catch (e) {
      print('General error: $e');
      Utils.flushBarErrorMessage('Upload failed: $e', context);
      return 'failed';
    }
  }

  Future<void> _updateBoolValue(String key, bool value) async {
    await SessionController.saveBool(key, value);
    setState(() {}); // Update UI if needed
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.950),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text('Create Bio'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 40.h),
                    child: Center(
                      child: CircleAvatar(
                        backgroundColor: Colors.grey[400],
                        maxRadius: 50,
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 5,
                                ),
                              ),
                              child: ClipOval(
                                child:
                                    _image == null
                                        ? Image.asset(
                                          'assets/images/profile copy.png',
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        )
                                        : Image.file(
                                          _image!,
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: InkWell(
                                onTap: () {
                                  _pickImage(ImageSource.gallery);
                                },
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  maxRadius: 18,
                                  child: Icon(
                                    Icons.camera_alt_outlined,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h),
                  const Row(
                    children: [
                      Text(
                        textAlign: TextAlign.start,
                        'About Me',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const Gap(10),
                  TextFormField(
                    controller: _meController,
                    maxLines: 6,
                    style: TextStyle(fontSize: 16, color: Colors.black),
                    decoration: InputDecoration(
                      hintText: 'please write about me',
                      hintStyle: TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          width: 0.2,
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          width: 0.2,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Gap(20),
                  const Row(
                    children: [
                      Text(
                        textAlign: TextAlign.start,
                        'City',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const Gap(10),
                  TextFormField(
                    style: TextStyle(fontSize: 16, color: Colors.black),
                    controller: _cityController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.location_on_outlined),
                      hintText: 'Enter your city',
                      hintStyle: TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          width: 0.2,
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          width: 0.2,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const Gap(100),
                  CustomButton(
                    isloading: _isLoading,
                    width: 400.0,
                    height: 50.0,
                    text: 'Save',
                    fontSize: 18.0,
                    // isloading: ,
                    onPressed: () async {
                      String result = await _uploadImage();
                      print(result);
                      if (result == 'success') {
                        _updateBoolValue(SessionController.boolKey1, true);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BusinessBuilder(),
                          ),
                        );
                        Utils.flushBarSuccessMessage(
                          'Bio updated successfully',
                          context,
                        );
                      }
                      ////functional code will be here
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
