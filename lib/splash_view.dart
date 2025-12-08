import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:personal_task/bottom_navigations.dart';
import 'package:personal_task/core/constants/app_colors.dart';
import 'package:personal_task/core/constants/app_strings.dart';
import 'package:personal_task/core/utils/DB/db_services.dart';
import 'package:personal_task/core/utils/notifications/local_notification_services.dart';
import 'package:personal_task/features/auth/views/login_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/utils/localization/l10n/app_localizations.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

import 'core/utils/localization/locale_provider.dart';
import 'core/utils/notifications/FCM_services.dart';

class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});

  @override
  ConsumerState<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startApp();
    });
  }

  Future<void> _startApp() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await Future.delayed(const Duration(seconds: 2));

    bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final fcmData = await FCMServices.initializeFCM();
    if (fcmData != null) {
      await prefs.setString("fcm_access_token", fcmData["token"]!);
      await prefs.setString("project_id", fcmData["projectId"]!);
      print("✔ FCM credentials saved");
    }

    if (isFirstTime) {
      prefs.setBool("isFirstTime", false);
    }

    // Permissions
    if (await Permission.scheduleExactAlarm.isDenied) {
      await Permission.scheduleExactAlarm.request();
    }
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }

    FirebaseMessaging.onMessage.listen((message) {
      LocalNotificationServices().showBasicNotification(
        id: 1,
        title: message.notification?.title ?? "Notification",
        body: message.notification?.body ?? "",
      );
    });

    FirebaseMessaging.instance.subscribeToTopic('public-tasks');

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Africa/Cairo'));

    // Navigate
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            isLoggedIn ? const BottomNavigations() : const LoginView(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.light,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: screenHeight * 0.4),
            Text(
              AppLocalizations.of(context)!.app_title,
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 70,
                fontFamily: ref.watch(localeProvider).languageCode == 'ar'
                    ? AppStrings.primaryArabicFont
                    : AppStrings.primaryFont,
              ),
              textAlign: TextAlign.center,
            ).animate().shimmer(duration: 1.seconds, color: AppColors.light),
            const Spacer(),
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
