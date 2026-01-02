import 'dart:convert';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FCMServices {
  static const String _serviceAccountPath =
      'assets/personla-task-firebase-adminsdk-fbsvc-da682b609a.json';
  static const String _serviceAccountPrefsKey = 'service_account_json';

  static Future<void> initializeServiceAccount() async {
    try {
      final jsonString = await rootBundle.loadString(_serviceAccountPath);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_serviceAccountPrefsKey, jsonString);
      print("[FCM] Service account JSON saved to SharedPreferences");
    } catch (e) {
      print("[FCM] Error initializing service account: $e");
    }
  }

  static Future<void> sendTopicNotification({
    required String topic,
    required String title,
    required String body,
  }) async {
    try {
      String? jsonString;

      try {
        jsonString = await rootBundle.loadString(_serviceAccountPath);
      } catch (e) {
        print("[FCM] rootBundle failed, trying SharedPreferences: $e");
        final prefs = await SharedPreferences.getInstance();
        jsonString = prefs.getString(_serviceAccountPrefsKey);

        if (jsonString == null) {
          print("[FCM] Service account not found in SharedPreferences");
          return;
        }
      }

      await _sendNotificationWithJson(
        jsonString: jsonString,
        topic: topic,
        title: title,
        body: body,
      );
    } catch (e) {
      print("SendTopicNotification Error: $e");
    }
  }

  static Future<void> sendTopicNotificationFromJson({
    required String jsonString,
    required String topic,
    required String title,
    required String body,
  }) async {
    try {
      await _sendNotificationWithJson(
        jsonString: jsonString,
        topic: topic,
        title: title,
        body: body,
      );
    } catch (e) {
      print("SendTopicNotificationFromJson Error: $e");
    }
  }

  static Future<void> _sendNotificationWithJson({
    required String jsonString,
    required String topic,
    required String title,
    required String body,
  }) async {
    try {
      final Map serviceAccount = jsonDecode(jsonString);
      final String projectId = serviceAccount["project_id"];

      final credentials = ServiceAccountCredentials.fromJson(serviceAccount);
      final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
      final client = await clientViaServiceAccount(credentials, scopes);
      final String accessToken = client.credentials.accessToken.data;

      final url = Uri.parse(
        'https://fcm.googleapis.com/v1/projects/$projectId/messages:send',
      );

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "message": {
            "topic": topic,
            "notification": {"title": title, "body": body},
            "android": {"priority": "high"},
            "apns": {
              "headers": {"apns-priority": "10"},
            },
          },
        }),
      );

      print("FCM Response (${response.statusCode}): ${response.body}");

      if (response.statusCode != 200) {
        print("[FCM] Failed to send notification: ${response.body}");
      }
    } catch (e) {
      print("_sendNotificationWithJson Error: $e");
      rethrow;
    }
  }
}
