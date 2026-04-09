import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:device_apps_plus/device_apps_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:personal_task/core/utils/localization/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

class Helpers {
  static const int firestoreMaxBytes = 1048487;

  static Future<bool> saveUID(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    print('uid saved $uid');
    return prefs.setString('uid', uid);
  }

  static Future<String?> getUID() async {
    final prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString('uid') ?? '';
    print(uid);
    return uid;
  }

  static Future<bool> toggleLoginState(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setBool('isLoggedIn', status);
  }

  static void displayDialog({
    required BuildContext context,
    required String title,
    required String message,
    required DialogType dialogType,
    required bool openMailOption,
    String? email,
  }) {
    AwesomeDialog(
      context: context,
      dialogType: dialogType,
      title: title,
      desc: message,
      dialogBackgroundColor: Theme.of(context).colorScheme.primaryContainer,
      titleTextStyle: TextStyle(color: Theme.of(context).colorScheme.surface),
      descTextStyle: TextStyle(color: Theme.of(context).colorScheme.surface,),
      btnOkText: openMailOption ? AppLocalizations.of(context)!.open_mail : null,
      btnOkOnPress: openMailOption
          ? () async {
        await DeviceAppsPlus().openApp('com.google.android.gm');
      }
          : null,
    ).show();
  }

  static Future<bool> isConnectedToInternet() async {
    const channel = MethodChannel('app.network/utils');
    try {
      return await channel.invokeMethod<bool>('isConnected') ?? false;
    } on PlatformException catch (e) {
      print('Error checking internet connection: $e');
      return false;
    }
  }

  static Future<String> imageToBase64(File file) async {
    return compute(_convertImageToBase64, file.path);
  }

  static String _convertImageToBase64(String filePath) {
    final file = File(filePath);
    final bytes = file.readAsBytesSync();
    final image = img.decodeImage(bytes);
    if (image == null) return '';

    List<int> finalBytes;
    final originalBytes = img.encodeJpg(image, quality: 100);

    if (originalBytes.length > firestoreMaxBytes) {
      final resized = img.copyResize(image, width: 800);
      finalBytes = img.encodeJpg(resized, quality: 70);
      if (finalBytes.length > firestoreMaxBytes) {
        print('Image too large after resizin'
            ''
            'g/compression, skipping.');
        return '';
      }
    } else {
      finalBytes = originalBytes;
    }

    return base64Encode(finalBytes);
  }

  static Future<String?> getCountryUsingGPS() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) return null;

    final pos = await Geolocator.getCurrentPosition();
    final placemarks = await placemarkFromCoordinates(pos.latitude, pos.longitude);

    return placemarks.isNotEmpty ? placemarks.first.country : null;
  }

  static String toArabicNumber(String input) {
    const englishToArabicDigits = {
      '0': '٠',
      '1': '١',
      '2': '٢',
      '3': '٣',
      '4': '٤',
      '5': '٥',
      '6': '٦',
      '7': '٧',
      '8': '٨',
      '9': '٩',
    };
    return input.split('').map((e) => englishToArabicDigits[e] ?? e).join();
  }

  static Future<int> generateUniqueNumber() async {
    final prefs = await SharedPreferences.getInstance();
    final lastValue = prefs.getInt('lastValue') ?? 0;
    final next = lastValue + 1;
    await prefs.setInt('lastValue', next);
    return next;
  }
  static Future<bool> saveString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    print("Data: $value");
    return await prefs.setString(key, value);
  }
  static Future<bool> saveBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(key, value);
  }
  static Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }
  static Future<bool?> getBool(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }
}
