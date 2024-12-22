import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'locationServices.dart';

class LocationDialog extends StatefulWidget {
  final VoidCallback onUseCurrentLocation;
  final VoidCallback onBack;
  final Function(String, double, double) onLocationSelected;

  const LocationDialog({
    required this.onUseCurrentLocation,
    required this.onBack,
    required this.onLocationSelected,
  });

  @override
  _LocationDialogState createState() => _LocationDialogState();
}

class _LocationDialogState extends State<LocationDialog> {
  String? selectedCity;
  String? selectedState;
  String? selectedCountry;
  double? latitude;
  double? longitude;
  final LocationService _locationService = LocationService();

  /// SharedPreferences Keys
  static const String _addressKey = 'address';
  static const String _latitudeKey = 'latitude';
  static const String _longitudeKey = 'longitude';

  /// Updates coordinates and stores the selected address
  Future<void> _updateCoordinates() async {
    try {
      // Convert address to coordinates
      List<Location> locations = await locationFromAddress(
        '$selectedCity, $selectedState, $selectedCountry',
      );
      if (locations.isNotEmpty) {
        latitude = locations[0].latitude;
        longitude = locations[0].longitude;

        // Store address in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        prefs.setString(_addressKey, '$selectedCity, $selectedState, $selectedCountry');
        prefs.setDouble(_latitudeKey, latitude!);
        prefs.setDouble(_longitudeKey, longitude!);

        // Notify parent widget
        widget.onLocationSelected(selectedCity!, latitude!, longitude!);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Location updated to $selectedCity, $selectedState, $selectedCountry.',
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch coordinates. Try again.')),
      );
    }
  }

  /// Displays the address input dialog
  void _showAddressInputDialog() {
    final TextEditingController addressController = TextEditingController();
    List<dynamic> suggestions = [];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Enter Location Manually'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: addressController,
                    decoration: InputDecoration(
                      hintText: 'Type your location',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () async {
                          if (addressController.text.isNotEmpty) {
                            try {
                              final response = await _locationService
                                  .fetchAutocompleteSuggestions(addressController.text);
                              setState(() {
                                suggestions = response['predictions'] ?? [];
                              });
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                    Text('Failed to fetch suggestions')),
                              );
                            }
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  if (suggestions.isNotEmpty)
                    Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: suggestions.length,
                        itemBuilder: (context, index) {
                          final suggestion = suggestions[index];
                          return ListTile(
                            title: Text(suggestion['description']),
                            onTap: () async {
                              // Fetch place details to get latitude and longitude
                              try {
                                final placeDetails = await _locationService
                                    .fetchPlaceDetails(suggestion['place_id']);

                                final lat = placeDetails['result']['geometry']['location']['lat'];
                                final lon = placeDetails['result']['geometry']['location']['lng'];
                                final city = suggestion['description'];

                                setState(() {
                                  selectedCity = city;
                                  latitude = lat;
                                  longitude = lon;
                                });

                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Location selected: $city')),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Failed to fetch place details')),
                                );
                              }
                            },
                          );
                        },
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancel'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: widget.onBack,
              ),
            ),
            Text(
              'Select Location',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: widget.onUseCurrentLocation,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16),
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.my_location, color: Colors.green),
                    SizedBox(width: 8),
                    Text(
                      'Use My Location',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: _showAddressInputDialog,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16),
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.edit_location, color: Colors.blue),
                    SizedBox(width: 8),
                    Text(
                      'Select Location',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
