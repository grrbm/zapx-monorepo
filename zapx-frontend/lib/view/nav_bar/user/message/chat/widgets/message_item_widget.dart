import 'dart:io';

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapxx/configs/app_url.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:zapxx/configs/components/timeformat.dart';
import 'package:zapxx/view/nav_bar/user/message/chat/messages_model.dart';

class MessageItem extends StatelessWidget {
  final MessageModel message;
  final bool isSent;

  const MessageItem({super.key, required this.message, required this.isSent});

  Widget _buildFilePreview(FileModel file) {
    final isImage = file.mimeType.startsWith('image/');
    final fileUrl = '${AppUrl.baseUrl}/${file.url}';

    return Container(
      margin: EdgeInsets.only(bottom: 4.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child:
            isImage
                ? file.isLocal
                    ? Image.file(File(file.url))
                    : CachedNetworkImage(
                      imageUrl: fileUrl,
                      width: 200.w,
                      height: 200.w,
                      fit: BoxFit.cover,
                      placeholder:
                          (context, url) => Container(
                            color: Colors.grey[200],
                            child: Center(child: CircularProgressIndicator()),
                          ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    )
                : file.isLocal
                ? Image.file(File(file.url))
                : Container(
                  color: Colors.grey[200],
                  padding: EdgeInsets.all(12.w),
                  child: Row(
                    children: [
                      Icon(Icons.insert_drive_file, size: 24.w),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              file.url.split('/').last,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: isSent ? Colors.white : Colors.black,
                              ),
                            ),
                            Text(
                              (file.mimeType), // Add size field to FileModel
                              style: TextStyle(
                                fontSize: 12.sp,
                                color:
                                    isSent ? Colors.white70 : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
        child: Column(
          crossAxisAlignment:
              isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (message.files.isNotEmpty)
              Column(children: message.files.map(_buildFilePreview).toList()),
            if (message.content != null)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: isSent ? AppColors.backgroundColor : Colors.grey[200],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(isSent ? 16.r : 0),
                    topRight: Radius.circular(isSent ? 0 : 16.r),
                    bottomLeft: Radius.circular(16.r),
                    bottomRight: Radius.circular(16.r),
                  ),
                ),
                child: Text(
                  message.content ?? '',
                  style: TextStyle(
                    color: isSent ? Colors.white : Colors.black,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            SizedBox(height: 4.h),
            Text(
              DateTimeFormatter.formatMessageTime(message.createdAt),
              style: TextStyle(
                color: isSent ? Colors.grey : Colors.grey[600],
                fontSize: 10.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
