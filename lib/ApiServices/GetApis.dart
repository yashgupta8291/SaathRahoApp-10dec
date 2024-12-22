import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiFunctionsGet {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  Future<int> MyListingCount() async {
    String? userId = await getUserId();
    if (userId == null) throw Exception('User not logged in.');

    final response = await http.get(
      Uri.parse('$baseUrl/getUserData?userId=$userId'),
      headers: {'Content-Type': 'application/json'},
    );

    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      // Parse the response body
      final Map<String, dynamic> data = jsonDecode(response.body);

      // Calculate the total count of objects inside arrays
      int totalCount = 0;
      for (var value in data.values) {
        if (value is List) {
          totalCount += value.length; // Count the number of items in each array
        }
      }

      return totalCount;
    } else {
      throw Exception('Failed to fetch user data: ${response.body}');
    }
  }

  // Get user ID from SharedPreferences
  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('uid');
  }

  // Check if a property is in the user's wishlist
  Future<bool> checkWishlistStatus(String propertyUid) async {
    String? userUid = await getUserId();
    if (userUid == null) throw Exception('User not logged in.');

    final response = await http.post(
      Uri.parse('$baseUrl/isPropertyInWishlist'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"UserUid": userUid, "ListingUId": propertyUid}),
    );

    print('Request body: {"UserUid": $userUid, "ListingUId": $propertyUid}');
    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body);
        // Ensure the expected key exists in the response
        return data['isInWishlist'] ?? false;
      } catch (e) {
        throw Exception('Error parsing response body: ${response.body}');
      }
    } else if (response.statusCode == 404) {
      return false; // Property not found in wishlist
    } else {
      throw Exception('Error checking wishlist status: ${response.body}');
    }
  }

  // Toggle wishlist status (add/remove property)
  Future<void> toggleWishlist(String propertyUid) async {
    String? userUid = await getUserId();
    if (userUid == null) throw Exception('User not logged in.');

    bool isInWishlist = await checkWishlistStatus(propertyUid);
    final endpoint = isInWishlist ? '/removeWishlist' : '/addWishlist';

    final response = await postRequest(endpoint, {
      'UserUid': userUid,
      'ListingUId': propertyUid,
    });

    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      print(isInWishlist
          ? 'Successfully removed from wishlist.'
          : 'Successfully added to wishlist.');
    } else {
      throw Exception('Error toggling wishlist status: ${response.body}');
    }
  }

  // Helper function to send POST requests
  Future<http.Response> postRequest(
      String endpoint, Map<String, dynamic> body) async {
    print('Request body: ${jsonEncode(body)}');
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      print('Request failed with status: ${response.statusCode}');
      print('Response Body: ${response.body}');
      throw Exception('Request failed with status: ${response.statusCode}');
    }
    return response;
  }
}
