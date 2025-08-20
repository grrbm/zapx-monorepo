import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapxx/configs/color/color.dart';

class AuthInputTextField extends StatefulWidget {
  final String hintText;
  final String prefixIcon;
  final bool isObscureText;
  final TextEditingController controller;
  final TextInputType textInputType;
  final Function(String)? onChanged;

  const AuthInputTextField(
      {super.key,
      required this.hintText,
      required this.prefixIcon,
      required this.isObscureText,
      required this.controller,
      required this.textInputType,
      this.onChanged});

  @override
  State<AuthInputTextField> createState() => _AuthInputTextFieldState();
}

class _AuthInputTextFieldState extends State<AuthInputTextField> {
  bool _isTextFieldEmpty = true;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateTextFieldEmptyStatus);
    _updateTextFieldEmptyStatus();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateTextFieldEmptyStatus);
    super.dispose();
  }

  void _updateTextFieldEmptyStatus() {
    setState(() {
      _isTextFieldEmpty = widget.controller.text.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8.h),
        TextField(
          onChanged: widget.onChanged,
          cursorColor: AppColors.blackColor,
          controller: widget.controller,
          obscureText: widget.isObscureText,
          keyboardType: widget.textInputType,
          style: TextStyle(
              color: AppColors.blackColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.normal,
              fontFamily: 'Poppins'),
          decoration: InputDecoration(
            hintText: widget.hintText,
            contentPadding:
                EdgeInsets.symmetric(vertical: 16.h, horizontal: 10),
            hintStyle: TextStyle(
              color: AppColors.greyColor.withOpacity(0.4),
            ),
            prefixIconConstraints: BoxConstraints(
              maxHeight: 44.h,
              maxWidth: 44.w,
            ),
            prefixIcon: Padding(
              padding: EdgeInsets.only(left: 10.w, right: 10.w),
              child: Image.asset(
                widget.prefixIcon,
                color: _isTextFieldEmpty
                    ? AppColors.greyColor.withOpacity(0.4)
                    : AppColors.backgroundColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: _isTextFieldEmpty
                    ? AppColors.greyColor.withOpacity(0.4)
                    : AppColors.greyColor.withOpacity(1),
                width: 0.0,
              ),
              borderRadius: BorderRadius.circular(8.r),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: AppColors.greyColor.withOpacity(0.4),
              ),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.greyColor.withOpacity(0.4),
              ),
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        ),
      ],
    );
  }
}
