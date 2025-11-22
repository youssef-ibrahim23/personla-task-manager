import 'package:flutter/material.dart';
import 'package:personal_task/core/constants/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final bool isHaveSuffixIcon;
  final TextInputType? keyboardType;
  final bool? profileState;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.isHaveSuffixIcon = false,
    this.profileState = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _isObscure;

  @override
  void initState() {
    super.initState();
    _isObscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return widget.profileState!
        ? Shimmer.fromColors(
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
    )
        : SizedBox(
      width: screenWidth * 0.9,
      height: screenHeight * 0.06,
      child: TextField(
        controller: widget.controller,
        obscureText: _isObscure,
        keyboardType: widget.keyboardType ?? TextInputType.text,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(width: 2, color: Colors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(width: 2, color: Colors.black),
          ),
          labelText: widget.hintText,
          labelStyle: const TextStyle(color: Colors.black),
          suffixIcon: widget.isHaveSuffixIcon
              ? IconButton(
            icon: Icon(
              _isObscure
                  ? Icons.remove_red_eye_outlined
                  : Icons.remove_red_eye,
            ),
            onPressed: () {
              setState(() {
                _isObscure = !_isObscure;
              });
            },
          )
              : null,
        ),
      ),
    );
  }
}
