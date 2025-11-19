import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:device_apps_plus/device_apps_plus.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Helpers {
  static Future<bool> saveUID(String uid) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString('uid', uid);
  }

  static Future<String?> getUID() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString('uid');
  }

  static Future<bool> toggleLoginState() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool isLoggedIn = preferences.getBool('isLoggedIn') ?? false;
    return await preferences.setBool('isLoggedIn', !isLoggedIn);
  }

  static void displayDialog({
    required BuildContext context,
    required String title,
    required String message,
    required DialogType dialogType,
    required bool isRegister,
    String? email,
  }) {
    AwesomeDialog(
      context: context,
      dialogType: dialogType,
      title: title,
      desc: message,
      btnOkText: isRegister ? 'Open Mail' : null,
      btnOkOnPress: isRegister
          ? () async {
        await DeviceAppsPlus().openApp('com.google.android.gm');
      }
          : null,
    ).show();
  }

  static Future<bool> isConnectedToInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
      return false;
    } on SocketException catch (e) {
      return false;
    }
  }

  static Future<String?> imageToBase64(File imageFile) async {
    try {
      if (await imageFile.exists()) {
        final bytes = await imageFile.readAsBytes();
        return base64Encode(bytes);
      }
      return null;
    } catch (e) {
      print('Error converting image to Base64: $e');
      return null;
    }
  }
}
