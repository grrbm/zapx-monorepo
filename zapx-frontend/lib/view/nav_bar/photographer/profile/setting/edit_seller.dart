import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_button.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/configs/utils.dart';
import 'package:zapxx/model/user/seller_model.dart';
import 'package:provider/provider.dart';
import 'package:zapxx/view_model/user_view_model.dart';

class EditSellerProfileScreen extends StatefulWidget {
  const EditSellerProfileScreen({super.key, required this.seller});
  final Seller? seller;
  @override
  State<EditSellerProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditSellerProfileScreen> {
  late TextEditingController controllerName;
  late TextEditingController controllerUserName;

  @override
  void initState() {
    super.initState();
    controllerName = TextEditingController(text: widget.seller?.aboutMe ?? '');
    controllerUserName = TextEditingController(
      text: widget.seller?.location ?? '',
    );
  }

  @override
  void didUpdateWidget(EditSellerProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.seller != widget.seller) {
      controllerName.text = widget.seller?.aboutMe ?? '';
      controllerUserName.text = widget.seller?.location ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserViewModel>(context, listen: false);
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back_ios, color: AppColors.blackColor),
        ),
        title: const CustomText(
          text: 'Edit Profiles',
          fontSized: 18.0,
          fontWeight: FontWeight.w600,
          color: AppColors.blackColor,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(thickness: 1),
            SizedBox(height: 46.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomPoppinText(
                    text: 'About me',
                    fontSized: 14.0,
                    color: AppColors.blackColor,
                    alignment: TextAlign.left,
                  ),
                  SizedBox(height: 8.h),
                  EditProfileTextField(
                    maxLines: 6,
                    controller: controllerName,
                    hintText: widget.seller?.aboutMe ?? '',
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 16.h),
                  const CustomPoppinText(
                    text: 'Location',
                    fontSized: 14.0,
                    color: AppColors.blackColor,
                    alignment: TextAlign.left,
                  ),
                  SizedBox(height: 8.h),
                  EditProfileTextField(
                    controller: controllerUserName,
                    hintText: widget.seller?.location ?? '',
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 26.h),
                  CustomButton(
                    title: 'Save Changes',
                    onPressed: () {
                      userProvider.setLoading(true);
                      Map data = {
                        "aboutMe": controllerName.text,
                        "location": controllerUserName.text,
                      };
                      userProvider
                          .updateSellerProfile(data)
                          .then((value) {
                            userProvider.setLoading(false);
                            if (!mounted) return;
                            Navigator.pop(context, true);
                            Future.delayed(Duration(milliseconds: 300), () {
                              if (!mounted) return;
                              Utils.flushBarSuccessMessage(
                                'User Updated Successfully',
                                context,
                              );
                            });
                          })
                          .catchError((error) {
                            userProvider.setLoading(false);
                            if (!mounted) return;
                            Future.delayed(Duration(milliseconds: 300), () {
                              if (!mounted) return;
                              Utils.flushBarErrorMessage(
                                error.toString(),
                                context,
                              );
                            });
                          });
                    },
                    btnColor: AppColors.backgroundColor,
                    btnTextColor: AppColors.whiteColor,
                  ),
                  SizedBox(height: 56.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditProfileTextField extends StatelessWidget {
  final String hintText;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final int? maxLines;
  EditProfileTextField({
    super.key,
    required this.hintText,
    required this.keyboardType,
    this.controller,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: maxLines,
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(
        color: AppColors.blackColor,
        fontSize: 14.sp,
        fontFamily: 'nunito sans',
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: AppColors.greyColor.withOpacity(0.5),
          fontSize: 14.sp,
          fontFamily: 'nunito sans',
        ),
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
