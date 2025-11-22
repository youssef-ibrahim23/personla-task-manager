import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:personal_task/core/constants/app_colors.dart';

class Button extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool state;

  const Button({
    super.key,
    required this.text,
    required this.onPressed,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return state
        ? LoadingAnimationWidget.stretchedDots(color: AppColors.primary, size: 40)
        : Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.06,
        decoration: BoxDecoration(
          color: state ? Colors.grey : Colors.green,
          borderRadius: BorderRadius.circular(12),
        ),
        child:  MaterialButton(
          onPressed: onPressed,
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: 'Luckiest Guy',
            ),
          ),
        ),
    );
  }
}
