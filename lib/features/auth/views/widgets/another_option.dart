import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../register_view.dart';

class AnotherOption extends StatelessWidget{

  bool isLogin;

  Widget page;

  AnotherOption({super.key , required this.isLogin , required this.page});

  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          isLogin
          ? "Already Have an Account?"
          : "Don't Have an Account?",
          style: TextStyle(color: AppColors.dark),
        ),
        TextButton(
          child: Text(
            isLogin
            ? "Login"
            : "Register",
            style: TextStyle(color: AppColors.primary),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => page,
              ),
            );
          },
        ),
      ],
    );
  }
}