import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:maan/Models/Bhojanalya.dart';
import 'package:maan/Models/Hostel.dart';
import 'package:maan/Models/Office.dart';
import 'package:maan/Models/Property.dart';
import 'package:maan/Models/roomate.dart';
import 'package:maan/Presentations/CategoryPages/CityCategoryPage.dart';
import 'package:maan/Presentations/PlanPages/LIstingPlanPage.dart';
import 'package:maan/Presentations/wishlist.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ApiServices/ApiServices.dart';
import '../ApiServices/GetApis.dart';
import '../Components/BottomNavBAr.dart';
import '../Components/customAppbar.dart';
import '../Components/locationServices.dart';
import '../Constants/AppConstants.dart';
import '../Models/User.dart';
import 'CategoryPages/office.dart';
import 'ChatPages/ChatPage.dart';
import 'DetailsPage/BhojnalayaDetailPage.dart';
import 'DetailsPage/FlatRoomDetailsPage.dart';
import 'DetailsPage/HostelDetailPage.dart';
import 'DetailsPage/OfficeDetailsPage.dart';
import 'DetailsPage/RommateDetail.dart';
import 'HomeContent.dart';
import 'locationPage.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool premium = true;
  int _selectedIndex = 0;
  List<dynamic> _searchResults = []; // Common list to store search results
  bool _isSearching = false;

  Future<void> _updateSearchResults(String query) async {
    setState(() {
      _isSearching = query.isNotEmpty;
    });

    if (_isSearching) {
      final results = await ApiFunctions.fetchSearchResults(query);
      setState(() {
        _searchResults = results;
      });
    } else {
      setState(() {
        _searchResults = [];
      });
    }
  }

  final List<Widget> _pages = [
    Homecontent(),
    ChatPage(),
    Center(child: Text('Third Page')),
    ListingPlanPage(isAppbar: false),
    WishlistPage(),
  ];
  bool isLoadingLocation = false;
  final LocationService _locationService = LocationService();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showLocationDialog();
    });
  }

  Future<void> _useCurrentLocation() async {
    setState(() {
      isLoadingLocation = true;
    });

    try {
      final locationData = await _locationService.fetchLocation();

      setState(() async {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString(
            'address', locationData['address'] ?? 'Select Location');
        isLoadingLocation = false;
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Location'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _useCurrentLocation();
                },
                child: Text('Use My Location'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return LocationPage();
                    },
                  ));
                },
                child: Text('Type Manually'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        IsSort: false,
        onSearch: _updateSearchResults,
        context: context, // Pass the search callback
      ),
      body: Column(
        children: [
          if (_isSearching) // Display search results when active
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final result = _searchResults[index];
                  return SearchListingCard(item: result);
                },
              ),
            ),
          if (!_isSearching) // Display home content when not searching
            Expanded(child: _pages[_selectedIndex]),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

class SearchListingCard extends StatefulWidget {
  final dynamic item;

  const SearchListingCard({Key? key, required this.item}) : super(key: key);

  @override
  State<SearchListingCard> createState() => _SearchListingCardState();
}

class _SearchListingCardState extends State<SearchListingCard> {
  bool isInWishlist = false;

  Future<void> CheckWishlist() async {
    bool inWishlist = await ApiFunctionsGet()
        .checkWishlistStatus(widget.item['result']['uid']);
    setState(() {
      isInWishlist = inWishlist;
    });
    print('Property is in wishlist: $isInWishlist');
  }

  @override
  void initState() {
    super.initState();
    CheckWishlist();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.item.keys);
    // Safely extract the 'result' and 'user' data from the item
    final result = widget.item['result'];
    final schema = widget.item['schema'];
    final userData = widget.item['user'];
    final User user = User.fromJson(userData);
    print("Schema: $schema");
    print('Result type: ${result.runtimeType}');
    print('Schema: $schema');
    // Create an appropriate model object based on schema
    var office;
    var hostel;
    var Bhojan;
    var roommate;
    var property;

    if (schema == 'OfficeListingForm') {
      print(result is Map<String, dynamic>);
      office = Office.fromJson(result); // Assuming `Office.fromJson` exists
    }
    if (schema == 'HostelDetailsForm') {
      hostel = Hostel.fromJson(result); // Assuming `Property.fromJson` exists
    }
    if (schema == 'RoommateForm') {
      roommate = Roommate.fromJson(result); // Assuming `Office.fromJson` exists
    }
    if (schema == 'RoomForm') {
      print(result.runtimeType);
      print('Raw JSON: $result');

      property =
          Property.fromJson(result); // Assuming `Property.fromJson` exists
    }
    if (schema == 'Bhojnalaya') {
      Bhojan = Bhojnalaya.fromJson(result); // Assuming `Office.fromJson` exists
    }

    // Debugging: Print the schema value

    return GestureDetector(
      onTap: () async {
        if (result == null) {
          // Handle the case when 'result' does not exist
          print("Error: 'result' not found in item.");
          return;
        }

        // Navigate to the appropriate detail page based on schema
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              if (schema == 'RoomForm') {
                return FlatDetailsPage(property: property, user: user);
              }
              if (schema == 'HostelDetailsForm') {
                return HostelDetailPage(hostel: hostel, user: user);
              }
              if (schema == 'OfficeListingForm') {
                return OfficeDetailPage(office: office, user: user);
              }
              if (schema == 'RoommateForm') {
                return RoommateDetail(roommate: roommate, user: user);
              }
              if (schema == 'Bhojnalaya') {
                return BhojnalayaDetailPage(bhojnalaya: Bhojan, user: user);
              }
              return SizedBox(); // Fallback if type does not match
            },
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            // Image placeholder
            Container(
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                    color: AppColors.card3,
                    child: result['FeatureListing'] == true
                        ? Text('Feature Listing')
                        : SizedBox()),
              ),
              width: 105,
              height: 160,
              decoration: BoxDecoration(
                image: result['images'].isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(result['images'][0] ?? ""))
                    : null,
                // color: Colors.red,
                borderRadius: BorderRadius.circular(10),

                // Add image fetching logic here if property image are available
              ),
            ),
            SizedBox(width: 12),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        // Check if 'title' is null or empty, then use 'name'. If both are null, display 'Unavailable'
                        result['title'] != null && result['title'].isNotEmpty
                            ? (result['title'].length > 20
                                ? result['title'].substring(0, 18)
                                : result['title'])
                            : (result['name'] != null &&
                                    result['name'].isNotEmpty
                                ? result['name']
                                : 'Unavailable'), // Fallback to 'Unavailable'
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 13.0),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle_outline),
                            IconButton(
                              onPressed: () async {
                                await ApiFunctionsGet()
                                    .toggleWishlist(result['uid']);
                                CheckWishlist();
                                setState(() {});
                              },
                              icon: Icon(
                                isInWishlist
                                    ? CupertinoIcons.heart_fill
                                    : CupertinoIcons.heart,
                                color: isInWishlist ? Colors.red : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(right: 25.0),
                    child: Text(
                      result['description'].toString(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(fontSize: 9),
                    ),
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Row(
                      children: [
                        Icon(Icons.location_on,
                            size: 10, color: Colors.black26),
                        Text(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          result['location'],
                          style: GoogleFonts.poppins(
                              fontSize: 9, color: Colors.black54),
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            '${DateFormat('yyyy-MM-dd').format(DateTime.parse(result['createdAt'].toString()))}',
                            style: GoogleFonts.poppins(
                                fontSize: 9, color: Colors.black54),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
