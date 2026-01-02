import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Button extends ConsumerStatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool state;
  final bool isGray;

  const Button({
    super.key,
    required this.text,
    required this.onPressed,
    required this.state,
    this.isGray = false,
  });

  @override
  ConsumerState<Button> createState() => _ButtonState();
}

class _ButtonState extends ConsumerState<Button> {


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return widget.state
        ? LoadingAnimationWidget.stretchedDots(color:theme.colorScheme.background, size: 40)
        : Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.06,
        decoration: BoxDecoration(
          color: widget.isGray ? Colors.grey : theme.colorScheme.background,
          borderRadius: BorderRadius.circular(12),
        ),
        child:  MaterialButton(
          onPressed: widget.onPressed,
          child: Text(
            widget.text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
    );
  }
}
