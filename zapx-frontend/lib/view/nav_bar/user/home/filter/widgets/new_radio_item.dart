import 'package:flutter/material.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';

class RadioItemNew extends StatelessWidget {
  final String title;
  final String value;
  final List<String> groupValues;
  final ValueChanged<String?> onChanged;

  const RadioItemNew({
    super.key,
    required this.title,
    required this.groupValues,
    required this.onChanged,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = groupValues.contains(value);

    return GestureDetector(
      onTap: () => onChanged(value),
      child: Row(
        children: [
          Radio<String>(
            value: value,
            groupValue: isSelected ? value : null,
            onChanged: onChanged,
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
