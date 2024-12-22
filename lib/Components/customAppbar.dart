import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maan/ApiServices/ApiServices.dart';
import 'package:maan/Constants/AppConstants.dart';
import 'package:maan/Presentations/Authentication/login.dart';
import 'package:maan/Presentations/UpdateProfile/ProfilePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../GetX/TokenController.dart';
import '../Presentations/locationPage.dart';
import 'locationDialog.dart';
import 'locationServices.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool IsSort;
  final BuildContext context;
  final ValueChanged<String> onSearch;

  const CustomAppBar({
    super.key,
    required this.onSearch,
    required this.IsSort,
    required this.context,
  });

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize =>
      Size.fromHeight(MediaQuery.of(context).size.width * 0.33);
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool isLogin = false;
  String uid = '';
  bool isLoadingLocation = false;
  final TokenController tokenController = Get.find();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _location = TextEditingController();
  final LocationService _locationService = LocationService();
  List<String> _suggestions = [];
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _searchController.addListener(() {
      widget.onSearch(_searchController.text);
    });
  }

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

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isLogin = prefs.getBool('isLogin') ?? false;
      uid = prefs.getString('uid') ?? '';
    });
  }

  Future<void> _useCurrentLocation() async {
    setState(() {
      isLoadingLocation = true;
    });

    try {
      final locationData = await _locationService.fetchLocation();
      setState(() {
        tokenController.address.value =
            locationData['address'] ?? 'Select Location';
        isLoadingLocation = false;
        ApiFunctions().UpdateAddress(tokenController.email.value,
            tokenController.address.value, context);
      });
    } catch (e) {
      setState(() {
        isLoadingLocation = false;
      });
      print("Error fetching location: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch location. Please try again.")),
      );
    }
  }

  void _showLocationDialog() {
    showModalBottomSheet(
      backgroundColor: AppColors.AppBar,
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.8,
          child: Container(
            child: Stack(children: [
              Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SvgPicture.asset(
                    'assets/svgs/SEARCH LOCATION.svg',
                    height: 400,
                    width: 400,
                  )),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Text(
                          'Select a Location',
                          style: GoogleFonts.poppins(fontSize: 12),
                        ),
                        SizedBox(height: 10),
                        Container(
                          height: 35,
                          child: TextField(
                            controller: _location,
                            decoration: InputDecoration(
                                fillColor: Colors.grey[200],
                                filled: true,
                                contentPadding: EdgeInsets.only(left: 15),
                                hintText: 'search for area city...',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontSize: 10)),
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                fetchAutocompleteSuggestions(value);
                              } else {
                                setState(() {
                                  _suggestions = [];
                                });
                              }
                            },
                          ),
                        ),
                        SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            _useCurrentLocation();
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                                border: Border.all(width: 0.5),
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey[200]),
                            height: 35,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.my_location,
                                  color: Colors.red,
                                  size: 14,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Choose Your Current Location",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 10),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Powered by',
                          style: GoogleFonts.poppins(fontSize: 8),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        SvgPicture.asset(
                          'assets/svgs/google.svg',
                          width: 30,
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _suggestions.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            _suggestions[index],
                            style: TextStyle(color: Colors.black),
                          ),
                          onTap: () async {
                            final prefs = await SharedPreferences.getInstance();
                            String selectedLocation = _suggestions[index] ?? '';

                            final String? email = prefs.getString('email');
                            if (email != null) {
                              await ApiFunctions().UpdateAddress(
                                  email, selectedLocation, context);
                              await prefs.setString(
                                  'address', selectedLocation);
                              tokenController.address.value = selectedLocation;
                            }

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Location saved: $selectedLocation')),
                            );

                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ]),
          ),
        );
      },
    );
  }

  Widget _buildUserInfo(double screenWidth) {
    return Row(
      children: [
        Icon(Icons.location_on,
            color: Colors.pink[300], size: screenWidth * 0.08),
        SizedBox(width: 8),
        GestureDetector(
          onTap: _showLocationDialog,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => Text(
                  'Hi ${tokenController.name.value}!',
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.038,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Row(
                children: [
                  if (isLoadingLocation)
                    SizedBox(
                      height: 20,
                      width: 20,
                      child: Center(
                        child: SizedBox(
                          height: 500,
                          child: Image.asset(
                            'assets/images/loading.gif',
                            width: 165,
                          ),
                        ),
                      ),
                    )
                  else
                    Obx(
                      () => Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 2.7,
                            child: Text(
                              maxLines: 1,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              tokenController.address.value == ''
                                  ? "Mumbai"
                                  : tokenController.address.value,
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.032,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          Icon(Icons.arrow_drop_down, color: Colors.black54),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileIcon(double screenWidth) {
    return !isLogin
        ? IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            icon: Icon(Icons.account_circle,
                size: screenWidth * 0.075, color: Colors.black87),
          )
        : GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            ),
            child: Obx(
              () => CircleAvatar(
                backgroundColor: Colors.grey,
                radius: screenWidth * 0.05,
                child: tokenController.profilePic.value.isNotEmpty
                    ? ClipOval(
                        child: Image.network(
                          tokenController.profilePic.value,
                          fit: BoxFit.cover,
                          width: screenWidth * 0.1,
                          height: screenWidth * 0.1,
                        ),
                      )
                    : Icon(Icons.person),
              ),
            ),
          );
  }

  Widget _buildSearchField(double screenWidth) {
    return SizedBox(
      height: screenWidth * 0.09,
      width: screenWidth * 0.7,
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search by category, location, price...',
          hintStyle: GoogleFonts.poppins(
            color: Colors.grey,
            fontSize: screenWidth * 0.03,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.035),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double paddingHorizontal = screenWidth * 0.04;
    double paddingVertical = screenWidth * 0.09;

    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: AppColors.AppBar,
      automaticallyImplyLeading: false,
      flexibleSpace: Padding(
        padding: EdgeInsets.only(
          top: paddingVertical,
          left: paddingHorizontal,
          right: paddingHorizontal,
        ),
        child: Stack(children: [
          Positioned(
              right: 0,
              top: 16,
              left: 130,
              bottom: 0,
              child: Image.asset('assets/images/searchbar.png')),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildUserInfo(screenWidth),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildProfileIcon(screenWidth),
                  ),
                ],
              ),
              SizedBox(height: paddingVertical * 0.21),
              _buildSearchField(screenWidth),
            ],
          ),
        ]),
      ),
    );
  }
}
