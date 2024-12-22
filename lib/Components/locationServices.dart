
// LocationService.dart (Utility class for handling location logic)

import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';



class LocationService {
  static const String _googleApiKey = 'AIzaSyAy9lpoCJKj3p-ez31H9mNw5dM115WJr1Y';

  // Existing methods...
  Future<Map<String, dynamic>> fetchLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception("Location permission denied");
        }
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Convert latitude and longitude to an address
      List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);
      String fetchedAddress =
          "${placemarks[0].name}, ${placemarks[0].locality}, ${placemarks[0].administrativeArea}, ${placemarks[0].country}";

      return {
        'latitude': position.latitude,
        'longitude': position.longitude,
        'address': fetchedAddress,
      };
    } catch (e) {
      throw Exception("Error fetching location: $e");
    }
  }

  Future<dynamic> fetchAutocompleteSuggestions(String query) async {
    try {
      final response = await http.get(
        Uri.parse('https://maps.googleapis.com/maps/api/place/autocomplete/json')
            .replace(queryParameters: {
          'input': query,
          'key': _googleApiKey,
          'types': '(cities)', // Optional: limit to cities
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to fetch autocomplete suggestions');
      }
    } catch (e) {
      throw Exception('Failed to fetch autocomplete suggestions');
    }
  }

  Future<dynamic> fetchPlaceDetails(String placeId) async {
    try {
      final response = await http.get(
        Uri.parse('https://maps.googleapis.com/maps/api/place/details/json')
            .replace(queryParameters: {
          'place_id': placeId,
          'key': _googleApiKey,
          'fields': 'geometry',
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to fetch place details');
      }
    } catch (e) {
      throw Exception('Failed to fetch place details');
    }
  }
}
