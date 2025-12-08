import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

class CustomDropDownButton extends StatelessWidget {
  final String hintText;
  final String? selectedValue;
  final List<String> options;
  final ValueChanged<String?> onChanged;

  const CustomDropDownButton({
    super.key,
    required this.hintText,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      padding: EdgeInsets.only(left: screenWidth * 0.03),
      width: screenWidth * 0.45,
      height: screenHeight * 0.06,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.dark, width: 2.0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: Text(hintText, style: const TextStyle(color: Colors.black)),
          value: selectedValue, // <-- Fully controlled
          isExpanded: true,
          style: const TextStyle(
            color: Colors.black,
            fontFamily: AppStrings.primaryFont,
            fontSize: 13,
          ),
          items: options
              .map((option) => DropdownMenuItem<String>(
            value: option,
            child: Text(option),
          ))
              .toList(),
          onChanged: onChanged, // Parent handles state
        ),
      ),
    );
  }
}
