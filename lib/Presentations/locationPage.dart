import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maan/GetX/TokenController.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ApiServices/ApiServices.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  TextEditingController _controller = TextEditingController();
  List<String> _suggestions = [];
  final TokenController tokenController = TokenController();
  // Function to fetch location suggestions
  Future<void> fetchAutocompleteSuggestions(String query) async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/autosuggest_google').replace(
          queryParameters: {
            'q': query,
          },
        ),
      );
      print(response.body); // Debugging response

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<String> suggestions = [];
        for (var prediction in data['predictions']) {
          suggestions.add(prediction['description']);
        }
        setState(() {
          _suggestions = suggestions;
        });
      } else {
        throw Exception('Failed to fetch autocomplete suggestions');
      }
    } catch (e) {
      print("Error fetching suggestions: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      String query = _controller.text;
      if (query.isNotEmpty) {
        fetchAutocompleteSuggestions(query); // Call the function with the query
      } else {
        setState(() {
          _suggestions = [];
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Location Search")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter location',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_suggestions[index]),
                    onTap: () async {
                      final prefs = await SharedPreferences.getInstance();
                      String selectedLocation = _suggestions[index] ?? '';

                      // Save the selected location in SharedPreferences
                      // final SharedPreferences prefs = await SharedPreferences.getInstance();
                      final String? email = prefs.getString('email');
                      if (email != null) {
                        print(selectedLocation);
                        // print(selectedLocation);
                        print(email);
                        await ApiFunctions()
                            .UpdateAddress(email, selectedLocation, context);
                        await prefs.setString('address', selectedLocation);
                        tokenController.address.value =
                            selectedLocation; // Save new name locally
                      }
                      // Optionally, show a confirmation message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Location saved: $selectedLocation')),
                      );

                      Navigator.pop(context);

                      /// Handle tap on a suggestion (optional)
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
