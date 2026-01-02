import 'package:flutter/material.dart';


class CustomDropDownButton extends StatelessWidget {
  final String hintText;
  final String? selectedValue;
  final List<String> options;
  final ValueChanged<String?> onChanged;
  final double? width;

  const CustomDropDownButton({
    super.key,
    required this.hintText,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      padding: EdgeInsets.only(left: screenWidth * 0.03 , right: screenWidth * 0.03 ),
      width: width ?? screenWidth * 0.45,
      height: screenHeight * 0.06,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).colorScheme.surface, width: 2.0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          dropdownColor: Theme.of(context).colorScheme.primaryContainer,
          iconEnabledColor: Theme.of(context).colorScheme.surface,
          hint: Text(hintText, style: TextStyle(color: Theme.of(context).colorScheme.surface , fontSize: 12)),
          value: selectedValue,
          isExpanded: true,
          items: options
              .map((option) => DropdownMenuItem<String>(
            value: option,
            child: Text(option ,style: TextStyle(color: Theme.of(context).colorScheme.surface),),
          ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
