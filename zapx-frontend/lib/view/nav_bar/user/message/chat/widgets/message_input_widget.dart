import 'dart:io';

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapxx/configs/app_url.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:dio/dio.dart';
import 'package:zapxx/configs/utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:zapxx/view/nav_bar/photographer/message/chat/create_offer/create_offer_screen.dart';
import 'package:zapxx/view/nav_bar/user/message/chat/messages_model.dart';
import 'package:zapxx/view_model/services/session_manager/session_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

class MessageInputWidget extends StatefulWidget {
  final Function(MessageModel message) onSendMessage;
  final String receiverId;
  final String? consumerId;
  final List<MessageModel> messages;
  final List<UserModel> chatUsers; // Add chat users to access consumer info
  final Function(Map<String, dynamic> offerData)?
  onOfferCreated; // Callback for offer data

  const MessageInputWidget({
    super.key,
    required this.onSendMessage,
    required this.receiverId,
    required this.consumerId,
    required this.messages,
    required this.chatUsers,
    this.onOfferCreated,
  });

  @override
  State<MessageInputWidget> createState() => _MessageInputWidgetState();
}

class _MessageInputWidgetState extends State<MessageInputWidget> {
  final TextEditingController _messageController = TextEditingController();
  bool _isSending = false;
  File? _selectedFile;

  // Helper method to get consumer ID from chat users
  String? _getConsumerId() {
    final currentUserId = SessionController().authModel.response.user.id;

    // Look through chat users to find the consumer
    for (var user in widget.chatUsers) {
      // Skip the current user
      if (user.id == currentUserId) continue;

      // Check if this user has a Consumer object
      if (user.consumer != null) {
        return user.consumer!.id.toString();
      }
    }
    return widget.consumerId;
  }

  // Helper method to get the other user's ID (not the current user)
  String? _getOtherUserId() {
    // Look through chat users to find the seller
    for (var user in widget.chatUsers) {
      // Find the user with role "SELLER" and return their seller ID
      if (user.role == 'SELLER' && user.seller != null) {
        return user.seller!.id.toString();
      }
    }
    return widget.receiverId;
  }

  // Helper method to get the other user's name
  String _getOtherUserName() {
    final currentUserId = SessionController().authModel.response.user.id;

    for (var user in widget.chatUsers) {
      if (user.id != currentUserId) {
        return user.fullName ?? 'User';
      }
    }
    return 'User';
  }

  Future<void> _sendMessageApi(
    String receiverId,
    String message,
    File? file,
  ) async {
    try {
      final dio = Dio(BaseOptions(baseUrl: AppUrl.baseUrl));
      final token = SessionController().authModel.response.token;

      final formData = FormData();

      if (file != null) {
        // Add the file if it exists
        formData.files.addAll([
          MapEntry(
            'files',
            await MultipartFile.fromFile(
              file.path,
              filename: file.path.split('/').last,
              contentType: DioMediaType.parse(
                lookupMimeType(file.path) ?? 'application/octet-stream',
              ),
            ),
          ),
        ]);
      }

      formData.fields.addAll([
        MapEntry('receiverId', receiverId),
        MapEntry('message', message),
      ]);
      print('FormData: ${formData.fields}');
      print('Files: ${formData.files}');

      final response = await dio.post(
        AppUrl.sendMessages,
        data: formData,
        options: Options(
          headers: {'Authorization': token, 'Accept': 'application/json'},
          contentType: 'multipart/form-data',
        ),
      );

      print('Upload response: ${response.data}');
      if (response.statusCode == 200) {}
    } on DioException catch (e) {
      print('Upload error: ${e.response?.data}');
      Utils.flushBarErrorMessage(
        e.response?.data['message'] ?? 'Upload failed',
        context,
      );
    } catch (e) {
      print('General error: $e');
      Utils.flushBarErrorMessage('Upload failed: $e', context);
    }
  }

  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  void _showPickerBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      elevation: 10,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      isScrollControlled: true,
      useSafeArea: true,
      builder:
          (context) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle
                Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 4),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Options list
                ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  children: [
                    _buildListTile(
                      icon: Icons.photo_library,
                      title: 'Photo Library',
                      onTap: () {
                        Navigator.pop(context);
                        _pickImageFromGallery();
                      },
                    ),
                    Divider(height: 1, color: Colors.grey[200]),
                    _buildListTile(
                      icon: Icons.insert_drive_file,
                      title: 'Files',
                      onTap: () {
                        Navigator.pop(context);
                        _pickFile();
                      },
                    ),
                    Divider(height: 1, color: Colors.grey[200]),
                    SessionController().authModel.response.user.role == 'SELLER'
                        ? _buildListTile(
                          icon: Icons.local_offer,
                          title: 'Create offer',
                          onTap: () {
                            final consumerId = _getConsumerId();
                            final otherUserId = _getOtherUserId();
                            print('Consumer ID: $consumerId');
                            print('Other User ID: $otherUserId');

                            if (consumerId == null) {
                              Utils.flushBarErrorMessage(
                                'Consumer information not found',
                                context,
                              );
                              return;
                            }

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => CreateOfferScreen(
                                      receiverId: consumerId,
                                      receiverName: _getOtherUserName(),
                                    ),
                              ),
                            ).then((result) {
                              // Handle the returned offer data
                              if (result != null &&
                                  result is Map<String, dynamic>) {
                                if (result['success'] == true &&
                                    result['offerData'] != null) {
                                  // Call the callback to handle offer data
                                  widget.onOfferCreated?.call(
                                    result['offerData'],
                                  );
                                }
                              }
                            });
                          },
                        )
                        : SizedBox.shrink(),
                  ],
                ),

                // Cancel button
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.all(8),
                  child: _buildListTile(
                    icon: Icons.close,
                    title: 'Cancel',
                    textColor: Colors.red,
                    onTap: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    Color? textColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      dense: true,
      leading: Icon(icon, color: textColor ?? Colors.black),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: textColor ?? Colors.black,
          fontWeight: FontWeight.w400,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  Widget _buildFilePreview() {
    if (_selectedFile == null) return const SizedBox.shrink();

    final fileName = _selectedFile!.path.split('/').last;
    final isImage =
        fileName.toLowerCase().endsWith('.png') ||
        fileName.toLowerCase().endsWith('.jpg') ||
        fileName.toLowerCase().endsWith('.jpeg');

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          isImage
              ? ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.file(
                  _selectedFile!,
                  width: 40.w,
                  height: 40.w,
                  fit: BoxFit.cover,
                ),
              )
              : Icon(Icons.insert_drive_file, size: 40.w),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${(_selectedFile!.lengthSync() / 1024).toStringAsFixed(1)} KB',
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, size: 20.w),
            onPressed: () => setState(() => _selectedFile = null),
          ),
        ],
      ),
    );
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty && _selectedFile == null) return;

    setState(() {
      _isSending = true;
    });

    try {
      String message = _messageController.text.trim();
      final tempMessage = MessageModel(
        id: 1,
        content: _messageController.text,
        createdAt: DateTime.now(),
        files:
            _selectedFile != null
                ? [
                  FileModel(
                    isLocal: true,
                    id: 1,
                    url: _selectedFile!.path, // Use local path temporarily
                    mimeType: lookupMimeType(_selectedFile!.path) ?? 'file',
                  ),
                ]
                : [],
        seenBy: [],
      );
      // Call the callback to update the parent widget's state

      if (message.isEmpty && _selectedFile != null) {
        message = ' ';
      }
      // Send API request with the message and selected file
      await _sendMessageApi(widget.receiverId, message, _selectedFile).then((
        _,
      ) {
        widget.onSendMessage(tempMessage);
      });

      // Clear the input field and reset file selection after sending
      _messageController.clear();
      setState(() {
        _selectedFile = null;
      });
    } catch (e) {
      print('Error sending message: $e');
    } finally {
      setState(() {
        _isSending = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildFilePreview(),
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        style: TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 14.sp,
                          fontFamily: 'Nunito Sans',
                        ),
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Your message',
                          hintStyle: TextStyle(
                            color: AppColors.greyColor,
                            fontSize: 14.sp,
                            fontFamily: 'Nunito Sans',
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 16,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle, color: Colors.black),
                      onPressed: _showPickerBottomSheet, // Select a file
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: AppColors.backgroundColor,
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: IconButton(
                icon:
                    _isSending
                        ? CircularProgressIndicator(color: AppColors.whiteColor)
                        : Image(
                          width: 24.w,
                          height: 24.w,
                          color: AppColors.whiteColor,
                          image: const AssetImage(
                            'assets/images/invite_friend.png',
                          ),
                        ),
                onPressed: _isSending ? null : _sendMessage, // Send message
              ),
            ),
          ],
        ),
      ],
    );
  }
}
