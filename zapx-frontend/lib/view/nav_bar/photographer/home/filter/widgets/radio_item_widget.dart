import 'package:flutter/material.dart';

import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';

class RadioItem extends StatelessWidget {
  String title;
  List<String> groupValues;
  ValueChanged<String> onChanged;
  RadioItem({
    super.key,
    required this.title,
    required this.groupValues,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(title);
      },
      child: Row(
        children: [
          Radio(
            value: groupValues.contains(title),
            groupValue: title,
            onChanged: (value) {
              onChanged(title);
            },
            activeColor: AppColors.backgroundColor,
          ),
          Expanded(
            child: CustomText(
              text: title,
              fontSized: 12.0,
              fontWeight: FontWeight.w500,
              color: AppColors.blackColor,
              alignment: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}
