import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:maan/Constants/AppConstants.dart';
import 'package:http/http.dart' as http;
import 'package:maan/Models/roomate.dart';
import 'package:maan/Presentations/DetailsPage/RommateDetail.dart';
import 'dart:convert';

import '../../ApiServices/GetApis.dart';
import '../../Components/customAppbar.dart';
import '../../FilterWidget.dart';
import '../../GetX/TokenController.dart';
import '../../Models/User.dart';
import '../DetailsPage/FlatRoomDetailsPage.dart';
import 'Hostel.dart';

class RoommateCategoryPage extends StatefulWidget {
  @override
  State<RoommateCategoryPage> createState() => _RoommateCategoryPageState();
}

class _RoommateCategoryPageState extends State<RoommateCategoryPage> {
  List<Roommate> _roommates = [];
  List<User> _user = [];
  bool _isLoading = true;
  final TokenController tokenController = Get.find();
  // Filter parameters
  String _priceFilter = '';
  String _gender = '';
  String _roomPref = '';
  String _locationPref = '';
  String _sort = '';

  @override
  void initState() {
    super.initState();
    fetchRoommates(); // Fetch all roommates initially
  }

  final Map<String, List<String>> _filterOptions = {
    // 'Price Range': ['0-5000', '5000-10000', '10000-15000', '15000+'],
    'Budget': [
      '0-5000',
      '5000-10000',
      '10000-15000',
      '15000+'
    ], // Price Range options
    'Gender': ['Male', 'Female'],
    'Location Preference': ['500', '1000', '1500'],
    'Room Preference': [
      '1 BHK',
      '2 BHK',
      '3 BHK',
      '4 BHK',
    ],
    'Sort by': [
      'Price : Low to High ',
      'Price : High to Low',
      'Recent Listings'
    ],
  };

  String _searchQuery = '';
  Future<void> SearchRoomates() async {
    String url;
    url = 'http://10.0.2.2:8000/api/search-roomates?q=${_searchQuery}';
    try {
      final uri = Uri.parse(url);

      // Make the HTTP GET request
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        // print(response.body);
        final jsonResponse = json.decode(response.body);

        // Parse properties based on the response structure
        final List roommates = jsonResponse['data'];

        setState(() {
          _roommates = roommates
              .map((data) => Roommate.fromJson(
                  data['roommate'])) // Explicitly extract 'room'
              .toList();

          _user = roommates
              .map((data) =>
                  User.fromJson(data['user'])) // Explicitly extract 'room'
              .toList();
        });
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        setState(() {
          _roommates = [];
        });
      }
    } catch (e) {
      print('Error fetching properties: $e');
      setState(() {
        _roommates = [];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> fetchRoommates() async {
    setState(() {
      _isLoading = true;
    });

    String url;
    Map<String, String> queryParams = {};

    try {
      // Determine if any filters are applied
      bool hasFilters = _priceFilter.isNotEmpty ||
          _gender.isNotEmpty ||
          _locationPref.isNotEmpty ||
          _sort.isNotEmpty ||
          _roomPref.isNotEmpty;

      if (hasFilters) {
        // Use filterRoommate endpoint
        url = 'http://10.0.2.2:8000/api/filter-roomates';

        // Add query parameters for filters
        if (_priceFilter.isNotEmpty)
          queryParams['startBudget'] = _priceFilter.split('-')[0];
        if (_priceFilter.isNotEmpty)
          queryParams['endBudget'] = _priceFilter.split('-')[1];
        if (_gender.isNotEmpty) queryParams['genderPreference'] = _gender;
        if (_roomPref.isNotEmpty) queryParams['roomPreference'] = _roomPref;
        if (_locationPref.isNotEmpty)
          queryParams['locationPreference'] = _locationPref;
        if (_sort.isNotEmpty) {
          queryParams['Preferences'] = _sort;
        }
      } else {
        // No filters, fetch all roommates
        url =
            'http://10.0.2.2:8000/api/roommates?city=${tokenController.address.value}';
      }

      // Construct URI with query parameters if filters are applied
      final uri = Uri.parse(url)
          .replace(queryParameters: hasFilters ? queryParams : null);

      // Make the HTTP GET request
      final response = await http.get(uri);
      // print(response.body);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        // Parse roommates based on the response structure
        final List roommates = hasFilters ? jsonResponse : jsonResponse;
        print(roommates);
        setState(() {
          _roommates = roommates
              .map((data) => Roommate.fromJson(
                  data['roommate'])) // Explicitly extract 'room'
              .toList();

          _user = roommates
              .map((data) =>
                  User.fromJson(data['user'])) // Explicitly extract 'room'
              .toList();
        });
      } else {
        print('Error: ${response.statusCode} - ${response.reasonPhrase}');
        setState(() {
          _roommates = [];
        });
      }
    } catch (e) {
      print('Error fetching roommates: $e');
      setState(() {
        _roommates = [];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _applyFilters(Map<String, dynamic> filters) {
    setState(() {
      _priceFilter = filters['Budget'] ?? '';
      _gender = filters['Gender'] ?? '';
      _roomPref = filters['Room Preference'] ?? '';
      _locationPref = filters['Location Preference'] ?? '';
      print(_locationPref);
      _sort = filters['Sort by'] ?? '';
    });

    fetchRoommates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onSearch: (query) {
          setState(() {
            _searchQuery = query;
          });
          if (_searchQuery == '') {
            fetchRoommates();
          }

          SearchRoomates();
        },
        IsSort: true,
        context: context,
      ),
      body: _isLoading
          ? Center(
              child: Center(
              child: SizedBox(
                height: 500,
                child: Image.asset(
                  'assets/images/loading.gif',
                  width: 165,
                ),
              ),
            ))
          : _roommates.isEmpty
              ? Center(child: Text('No roommates found'))
              : SingleChildScrollView(
                  child: RoommateListingList(roommate: _roommates, user: _user),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => FilterBottomSheet(
              filters: _filterOptions,
              onApply: _applyFilters,
            ),
          );
        },
        child: Icon(Icons.filter_list),
      ),
    );
  }
}

class RoommateListingList extends StatelessWidget {
  final List<Roommate> roommate;
  final List<User> user;

  const RoommateListingList({required this.roommate, required this.user});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: roommate.length,
      itemBuilder: (context, index) {
        return RoommateListingCard(
            roommate: roommate[index], user: user[index]);
      },
    );
  }
}

class RoommateListingCard extends StatefulWidget {
  final Roommate roommate;
  final User user;

  const RoommateListingCard({required this.roommate, required this.user});

  @override
  State<RoommateListingCard> createState() => _RoommateListingCard();
}

class _RoommateListingCard extends State<RoommateListingCard> {
  bool isInWishlist = false;

  Future<void> CheckWishlist() async {
    bool inWishlist =
        await ApiFunctionsGet().checkWishlistStatus(widget.roommate.id);
    setState(() {
      isInWishlist = inWishlist;
    });
    print('roommate is in wishlist: $isInWishlist');
  }

  @override
  void initState() {
    // TODO: implement initState
    CheckWishlist();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return RoommateDetail(
              user: widget.user,
              roommate: widget.roommate,
            );
          },
        ));
      },
      child: Stack(children: [
        Padding(
          padding: const EdgeInsets.all(13.0),
          child: Container(
            height: 140,
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                border: Border.all(width: 0.5),
                borderRadius: BorderRadius.circular(15)),
            child: Row(
              children: [
                // Image placeholder
                Container(
                  width: 120,
                  height: 187,
                  decoration: BoxDecoration(
                    image: widget.roommate.image.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(widget.roommate.image[0]),
                            fit: BoxFit.fill)
                        : null,
                    // color: Colors.red,
                    borderRadius: BorderRadius.circular(10),

                    // Add image fetching logic here if roommate image are available
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
                              widget.roommate.title.length > 20
                                  ? widget.roommate.title.substring(0, 18)
                                  : widget
                                      .roommate.title, // limit to 20 characters
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (widget.user.verified)
                                // SvgPicture.asset('assets/svgs/Veified.svg',width: 25,),
                                Icon(
                                  Icons.check_circle,
                                  color: Color.fromRGBO(77, 102, 159, 1.0),
                                ),
                              Padding(
                                padding: const EdgeInsets.only(right: 3.0),
                                child: IconButton(
                                  onPressed: () async {
                                    await ApiFunctionsGet()
                                        .toggleWishlist(widget.roommate.id);
                                    CheckWishlist();
                                    setState(() {});
                                  },
                                  icon: Icon(
                                    isInWishlist
                                        ? CupertinoIcons.heart_fill
                                        : CupertinoIcons.heart,
                                    color: isInWishlist
                                        ? Colors.red
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // SizedBox(height: 6),
                      Text(
                        'INR: ${widget.roommate.price}',
                        style: GoogleFonts.poppins(
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.only(right: 25.0),
                        child: Text(
                          widget.roommate.description.toString(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(fontSize: 9),
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.location_on,
                                  size: 12, color: Colors.black26),
                              Text(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                widget.roommate.location,
                                style: GoogleFonts.poppins(
                                    fontSize: 9, color: Colors.black54),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 15.0),
                            child: Text(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              '${DateFormat('dd-MM-yyyy').format(DateTime.parse(widget.roommate.createdAt.toString()))}',
                              style: GoogleFonts.poppins(
                                  fontSize: 9, color: Colors.black54),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (widget.roommate.featureListing)
          Positioned(
            top: -25,
            left: 8,
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 1.2, top: 1.2),
                child:  Image.asset(
                        'assets/images/Featured.png',
                        width: 90,
                        // height: 20,
                      )
              ),
            ),
          )
      ]),
    );
  }
}
