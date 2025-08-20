import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:zapxx/configs/app_url.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/utils.dart';
import 'package:zapxx/view/nav_bar/photographer/home/business_builder/business_builder.dart';
import 'package:zapxx/view_model/services/session_manager/session_controller.dart';

class PortFolioScreen extends StatefulWidget {
  const PortFolioScreen({super.key});

  @override
  State<PortFolioScreen> createState() => _PortFolioScreenState();
}

class _PortFolioScreenState extends State<PortFolioScreen> {
  List<File> _selectedImages = [];
  String _portfolioTitle = "Title"; // Default title
  bool _isEditingTitle = false; // State to toggle title editing
  bool _isLoading = false;
  Future<void> _updateBoolValue(String key, bool value) async {
    await SessionController.saveBool(key, value);
    setState(() {}); // Update UI if needed
  }

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

  // Function to upload images and title
  Future<void> _uploadPortfolio() async {
    if (_portfolioTitle.isEmpty || _selectedImages.isEmpty) {
      Utils.flushBarErrorMessage(
        'Please add a title and at least one image.',
        context,
      );
      return;
    }

    try {
      final dio = Dio(BaseOptions(baseUrl: AppUrl.baseUrl));
      final token =
          SessionController()
              .authModel
              .response
              .token; // Replace with the actual token
      setState(() {
        _isLoading = true;
      });

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

      // Add title to FormData
      formData.fields.addAll([MapEntry('title', _portfolioTitle)]);

      final response = await dio.post(
        AppUrl.portfolioEndPoint, // Replace with your API endpoint
        data: formData,
        options: Options(
          headers: {'Authorization': token, 'Accept': 'application/json'},
          contentType: 'multipart/form-data',
        ),
      );

      if (response.statusCode == 200) {
        Utils.flushBarSuccessMessage(
          'Portfolio uploaded successfully!',
          context,
        );
        setState(() {
          _selectedImages.clear();
          _portfolioTitle = "Title";
          _isEditingTitle = false;
        });
        _updateBoolValue(SessionController.boolKey3, true);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const BusinessBuilder();
            },
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Upload failed. Please try again.')),
        );
      }
    } on DioException catch (e) {
      print('Upload error: ${e.response?.data}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.response?.data['message'] ?? 'Upload failed')),
      );
    } catch (e) {
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

  @override
  Widget build(BuildContext context) {
    late TextEditingController _controller = TextEditingController();
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
          'Portfolio',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(thickness: 1),
            const SizedBox(height: 40),
            Row(
              children: [
                _isEditingTitle
                    ? Expanded(
                      child: TextField(
                        style: const TextStyle(color: Colors.black),
                        autofocus: true,
                        controller: _controller,
                        onSubmitted: (value) {
                          setState(() {
                            _portfolioTitle =
                                value.isEmpty ? _portfolioTitle : value;
                            _isEditingTitle = false;
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: "Enter portfolio title",
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                        ),
                      ),
                    )
                    : Expanded(
                      child: Text(
                        _portfolioTitle,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                IconButton(
                  icon: Icon(
                    _isEditingTitle ? Icons.check : Icons.edit,
                    size: 20,
                    color: AppColors.backgroundColor,
                  ),
                  onPressed: () {
                    setState(() {
                      _portfolioTitle = _controller.text;
                      _isEditingTitle = !_isEditingTitle;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
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
                                borderRadius: BorderRadius.circular(10),
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
            const Spacer(),
            _isLoading
                ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.backgroundColor,
                  ),
                )
                : GestureDetector(
                  onTap: () async {
                    await _uploadPortfolio();
                  },
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                      child: Text(
                        'Post',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
