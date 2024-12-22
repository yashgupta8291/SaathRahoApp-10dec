import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../GetX/pincodeController.dart';

class LocationFromPincode {
  // Dependency Injection: Ensure the controller is properly registered
  final PincodeController pincodeController = Get.find<PincodeController>();

  Future<bool> getLocation({required String pincode}) async {
    String apiUrl = "https://api.postalpincode.in/pincode/$pincode";
    try {
      // Sending GET request
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        print("API Response: ${response.body}");

        // Decode and handle API response
        final res = jsonDecode(response.body);
        print(res);
        if (res is List && res.isNotEmpty && res[0]['PostOffice'] != null) {
          pincodeController.pincode.value =
              res[0]['PostOffice'][0]['District'] ?? "Unknown District";
          return true;
        } else {
          print("Invalid API Response: $res");
          return false;
        }
      } else {
        print("API Error: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Exception: $e");
      return false;
    }
  }
}
