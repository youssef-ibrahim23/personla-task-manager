import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:device_apps_plus/device_apps_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

class Helpers {
  static const int firestoreMaxBytes = 1048487;

  static Future<bool> saveUID(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString('uid', uid);
  }

  static Future<String?> getUID() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('uid');
  }

  static Future<bool> toggleLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    return prefs.setBool('isLoggedIn', !isLoggedIn);
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
      btnOkText: openMailOption ? 'Open Mail' : null,
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
        print('Image too large after resizing/compression, skipping.');
        return '';
      }
    } else {
      finalBytes = originalBytes;
    }

    return base64Encode(finalBytes);
  }

  static Future<File?> imageToFile(String base64String, String path) async {
    try {
      final bytes = base64Decode(base64String);
      final file = File(path);
      await file.writeAsBytes(bytes);
      return file;
    } catch (e) {
      print('Error converting Base64 to file: $e');
      return null;
    }
  }

  static Future<String?> getCountryUsingGPS() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) return null;

    final pos = await Geolocator.getCurrentPosition();
    final placemarks = await placemarkFromCoordinates(pos.latitude, pos.longitude);

    return placemarks.isNotEmpty ? placemarks.first.country : null;
  }
}
