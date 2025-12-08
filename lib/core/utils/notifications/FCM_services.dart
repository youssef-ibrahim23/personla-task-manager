import 'dart:convert';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class FCMServices {
  static const String _serviceAccountPath =
      'assets/personla-task-firebase-adminsdk-fbsvc-85e4b65bb5.json';

  static Future<Map<String, String>?> initializeFCM() async {
    try {
      final jsonString = await rootBundle.loadString(_serviceAccountPath);
      final Map serviceAccount = jsonDecode(jsonString);

      final String projectId = serviceAccount["project_id"];

      final credentials =
      ServiceAccountCredentials.fromJson(serviceAccount);

      final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

      final client = await clientViaServiceAccount(credentials, scopes);

      final String accessToken = client.credentials.accessToken.data;

      client.close();

      return {
        "token": accessToken,
        "projectId": projectId,
      };
    } catch (e) {
      print("Error initializing FCM: $e");
      return null;
    }
  }

  static Future<void> sendTopicNotification({
    required String topic,
    required String title,
    required String body,
    required String accessToken,
    required String projectId,
  }) async {
    try {
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
            "notification": {
              "title": title,
              "body": body,
            },
            "android": {"priority": "high"},
            "apns": {
              "headers": {"apns-priority": "10"},
            },
          },
        }),
      );

      print("FCM Response (${response.statusCode}): ${response.body}");
    } catch (e) {
      print("SendTopicNotification Error: $e");
    }
  }
}
