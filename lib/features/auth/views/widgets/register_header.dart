import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';

class RegisterHeader extends StatelessWidget{
  const RegisterHeader({super.key});


  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Text(
          "Personal Tasks",
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontFamily: AppStrings.primaryFont,
            fontSize: 40,
          ),
        ),
        Text(
          "Create Your Account",
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 18,
            fontFamily: AppStrings.primaryFont,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}