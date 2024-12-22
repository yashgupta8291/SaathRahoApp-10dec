import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maan/ApiServices/ApiServices.dart';

class SendChatNotification {
  static Future<void> sendChatNotification(String id, String name) async {
    try {
      final Map<String, dynamic> body = {
        'recipientUserId': id,
        'message': '$name sent you a message',
        'title': 'RoomieQ',
      };

      final response = await http.post(
        Uri.parse('${ApiFunctions.baseUrl}/send-notification'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print('Notification sent successfully');
        final responseData = jsonDecode(response.body);
        print('Response: $responseData');
      } else {
        print(
            'Failed to send notification. Status code: ${response.statusCode}');
        print('Error: ${response.body}');
      }
    } catch (error) {
      print('Error sending notification: $error');
    }
  }
}