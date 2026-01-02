import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

@immutable
class CustomTextField extends ConsumerStatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  bool obscureText;
  final bool isPassword;
  final TextInputType? keyboardType;
  final bool profileState;
  final ValueChanged<String>? onChanged;
  final IconData? suffixIcon;

  CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.profileState = false,
    this.onChanged,
    this.suffixIcon,
  });

  @override
  ConsumerState<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends ConsumerState<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);

    if (widget.profileState) {
      return Shimmer.fromColors(
        baseColor: theme.primaryColor,
        highlightColor: Colors.white,
        child: Container(
          width: screenWidth * 0.8,
          height: screenHeight * 0.06,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      width: screenWidth * 0.9,
      height: screenHeight * 0.06,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        style: TextStyle(
          fontFamily: 'Rakkas-Regular',
          color: theme.colorScheme.surface,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.2,
        ),
        controller: widget.controller,
        obscureText: widget.obscureText,
        keyboardType: widget.keyboardType ?? TextInputType.text,
        onChanged: (value){
          widget.onChanged?.call(value);
        },
        cursorColor: theme.colorScheme.surface,
        cursorWidth: 1.5,
        cursorRadius: const Radius.circular(1),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
            fontFamily: 'Rakkas-Regular',
            color: theme.colorScheme.surface.withOpacity(0.6),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          filled: true,
          fillColor: theme.colorScheme.primaryContainer,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: theme.colorScheme.surface.withOpacity(0.5),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: theme.colorScheme.primary,
              width: 2,
            ),
          ),
          suffixIcon: widget.isPassword
              ? Padding(
            padding: const EdgeInsets.only(right: 8 , left: 8),
            child: IconButton(
              icon: Icon(
                widget.obscureText
                    ? Icons.visibility_off_outlined
                    : Icons.visibility,
                size: 22,
              ),
              onPressed: () {
                setState(() {
                  widget.obscureText = !widget.obscureText;
                });
              },
              splashRadius: 20,
            ),
          )
              : widget.suffixIcon != null
              ? Padding(
            padding: const EdgeInsets.only(right: 16 , left: 12),
            child: Icon(
              widget.suffixIcon,
              size: 22,
            ),
          )
              : null,
        ),
      ),
    );
  }
}