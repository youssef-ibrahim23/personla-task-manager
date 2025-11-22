import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:personal_task/core/constants/app_colors.dart';
import 'package:personal_task/features/home/view/home_view.dart';
import 'package:personal_task/features/auth/views/login_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/utils/localization/l10n/app_localizations.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 3), () async {
      SharedPreferences preferences = await SharedPreferences.getInstance();

      bool isFirstTime = preferences.getBool('isFirstTime') ?? true;

      if (isFirstTime) {
        await preferences.setBool('isFirstTime', false);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginView()),
        );
      } else {
        bool isLoggedIn = preferences.getBool('isLoggedIn') ?? false;
        if (isLoggedIn) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeView()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginView()),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.light,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: screenHeight * 0.4),
            Text(
              AppLocalizations.of(context)!.app_title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 70,
                fontFamily: 'Luckiest Guy',
              ),
            ).animate().shimmer(duration: 1.seconds, color: AppColors.light),
            Spacer(),
            Image.asset("assets/images.png")
                .animate()
                .move(begin: const Offset(0, 100), duration: 1.seconds)
                .then()
                .shake(hz: 0.5, curve: Curves.easeInOut, duration: 2000.ms),
          ],
        ),
      ),
    );
  }
}
