import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
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
    return await preferences.setBool('isLoggedIn',!isLoggedIn);
  }

  static void displayDialog(
    BuildContext context,
    String title,
    String message,
    DialogType dialogType,
  ) {
    AwesomeDialog(
      context: context,
      dialogType: dialogType,
      title: title,
      desc: message,
    ).show();
  }

  static Future<bool> isConnectedToInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
      return false;
    } on SocketException catch (_) {
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
