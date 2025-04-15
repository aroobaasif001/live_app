import 'package:cloud_firestore/cloud_firestore.dart';

import 'get_server_key.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SendNotificationService {
  static Future<void> sendNotificationUsingApi({
    required String? token,
    required String? title,
    required String? body,
    required Map<String, dynamic>? data,
  }) async {
    String serverKey = await GetServerKey().getServerKeyToken();

    String url =
        "https://fcm.googleapis.com/v1/projects/hvatai/messages:send";

    var headers = <String, String>{
      'Authorization': 'Bearer $serverKey',
      'Content-Type': 'application/json',
    };

    Map<String, dynamic> message = {
      "message": {
        "token": token,
        "notification": {"body": body, "title": title},
        "data": data
      }
    };

    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {
      print("Notification sent successfully!");
    } else {
      print("Failed to send notification. Status code: ${response.statusCode}");
      print("Response body: ${response.body}");
    }
  }
   static Future<void> sendToAllUserEntityTokens({
    required String title,
    required String body,
    required Map<String, dynamic> data,
  }) async {
    try {
      final usersSnapshot = await FirebaseFirestore.instance
          .collection('UserEntity')
          .get();

      for (var doc in usersSnapshot.docs) {
        final userData = doc.data();
        final token = userData['fcmToken'];

        if (token != null && token is String && token.isNotEmpty) {
          await sendNotificationUsingApi(
            token: token,
            title: title,
            body: body,
            data: data,
          );
        }
      }

      print("✅ Notification sent to all users in UserEntity.");
    } catch (e) {
      print("❌ Failed to send notifications to all users: $e");
    }
  }

}