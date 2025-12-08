import 'package:flutter/material.dart';
import 'package:personal_task/core/constants/app_colors.dart';
import 'package:personal_task/core/constants/app_strings.dart';
import 'package:shimmer/shimmer.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  bool obscureText;
  final bool isHaveSuffixIcon;
  final TextInputType? keyboardType;
  final bool profileState;
  final ValueChanged<String>? onChanged;
  final String fontFamily;

   CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.isHaveSuffixIcon = false,
    this.profileState = false,
    this.onChanged,
     required this.fontFamily,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    if (widget.profileState) {
      return Shimmer.fromColors(
        baseColor: AppColors.primary,
        highlightColor: Colors.white,
        child: Container(
          width: screenWidth * 0.8,
          height: screenHeight * 0.06,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }

    return SizedBox(
      width: screenWidth * 0.9,
      height: screenHeight * 0.06,
      child: TextField(
        controller: widget.controller,
        obscureText: widget.obscureText,
        keyboardType: widget.keyboardType ?? TextInputType.text,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          labelText: widget.hintText,
          labelStyle: TextStyle(letterSpacing: 1 , color: Colors.black , fontSize: 15 , fontFamily: widget.fontFamily),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(width: 2, color: Colors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(width: 2, color: Colors.black),
          ),

          suffixIcon: widget.isHaveSuffixIcon
              ? IconButton(
            icon: Icon(
              widget.obscureText
                  ? Icons.visibility_off_outlined
                  : Icons.visibility,
            ),
            onPressed: () {
              setState(() {
                widget.obscureText = !widget.obscureText;
              });
            },
          )
              : null,
        ),
      ),
    );
  }
}
