import 'package:flutter/material.dart';

class Button extends StatelessWidget {

  String text;
  VoidCallback onPressed;
  bool state;

  Button({required this.text, required this.onPressed, required this.state ,  super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.06,
      decoration: BoxDecoration(
        color: state
            ? Colors.grey
            : Colors.green,
        borderRadius: BorderRadius.circular(12),
      ),
      child: MaterialButton(
        onPressed: onPressed,
        child: Text(
          state ? text : text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'Luckiest Guy',
          ),
        ),
      ),
    );
  }
}