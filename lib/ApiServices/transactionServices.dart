import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maan/ApiServices/ApiServices.dart';

class Transaction {
  Future<String> createTransaction({
    required String token,
    required double amount,
    required String membership,
  }) async {
    const String apiUrl =
        "${ApiFunctions.baseUrl}/create-transaction"; // Replace <your_base_url> with your API URL
    try {
      // Request headers
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Ensure token-based authentication
      };

      // Request body
      final body = jsonEncode({
        'amount': amount,
        'membership': membership,
      });

      // Sending POST request
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: body,
      );

      // Check the response status
      if (response.statusCode == 201) {
        print(response.body);
        return
          jsonDecode(response.body)['data'];
      } else {
        // Handle error response
        return
          jsonDecode(response.body)['message'] ?? 'Unknown error occurred';
      }
    } catch (e) {
      // Handle exceptions
      return 'message' ;
    }
  }
}