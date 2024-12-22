import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:maan/Constants/AppConstants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../ApiServices/GetApis.dart';
import '../../Components/customAppbar.dart';
import '../../FilterWidget.dart';
import '../../GetX/TokenController.dart';
import '../../Models/Hostel.dart';
import '../../Models/Property.dart';
import '../../Models/User.dart';
import '../DetailsPage/FlatRoomDetailsPage.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';

class PropertyCategoryPage extends StatefulWidget {
  @override
  State<PropertyCategoryPage> createState() => _PropertyCategoryPageState();
}

class _PropertyCategoryPageState extends State<PropertyCategoryPage> {
  List<Property> _properties = [];
  List<User> _user = [];
  bool _isLoading = true;
  String _searchQuery = '';
  final TokenController tokenController = Get.find();

  Future<void> SearchProperties() async {
    String url;
    url = 'http://10.0.2.2:8000/api/search-rooms?q=${_searchQuery}';
    try {
      final uri = Uri.parse(url);

      // Make the HTTP GET request
      final response = await http.get(uri);
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print(response.body);
        // Parse properties based on the response structure
        final List properties = jsonResponse['data'];

        setState(() {
          _properties = properties
              .map((data) =>
                  Property.fromJson(data['room'])) // Explicitly extract 'room'
              .toList();
          _user = properties
              .map((data) =>
                  User.fromJson(data['user'])) // Explicitly extract 'room'
              .toList();
        });
      } else {
        print('Error: ${response.statusCode} - ${response.reasonPhrase}');
        setState(() {
          _properties = [];
        });
      }
    } catch (e) {
      print('Error fetching properties: $e');
      setState(() {
        _properties = [];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Define filter options
  final Map<String, List<String>> _filterOptions = {
    // 'Price Range': ['0-5000', '5000-10000', '10000-15000', '15000+'],
    'Price Range': [
      '0-5000',
      '5000-10000',
      '10000-15000',
      '15000+'
    ], // Price Range options

    'Bedrooms': ['1', '2', '3', '4+'],
    'Sort by': [
      'Price : Low to High ',
      'Price : High to Low',
      'Recent Listings'
    ],
    // 'Category': ['Apartment', 'House', 'PG', 'Hostel'],
    'Listed by': ['Owner', 'Rental'],
    'Square Build-Up Area': ['500', '1000', '1500'],
    'Bachelor Allowance': ['Yes', 'No'],
    'Furnished': ['Fully Furnished', 'Semi Furnished', 'Unfurnished'],
  };

  // Filter values
  String _priceFilter = '';
  String _bedrooms = '';
  String _categoryType = '';
  String _furnished = '';
  String listedBy = '';
  String area = '';
  String bachelor = '';
  String sort = '';

  @override
  void initState() {
    super.initState();
    fetchProperties();
  }

  Future<void> fetchProperties() async {
    setState(() {
      _isLoading = true;
    });

    String url;
    Map<String, String> queryParams = {};

    try {
      // Determine if any filters or search query are applied
      bool hasFilters = _priceFilter.isNotEmpty ||
          _bedrooms.isNotEmpty ||
          listedBy.isNotEmpty ||
          _furnished.isNotEmpty ||
          bachelor.isNotEmpty ||
          area.isNotEmpty ||
          sort.isNotEmpty ||
          _categoryType.isNotEmpty;

      if (hasFilters) {
        // Use the search endpoint
        url = 'http://10.0.2.2:8000/api/search-rooms-filters';

        // Add search query and filter parameters
        if (_priceFilter.isNotEmpty)
          queryParams['startMonthlyMaintenance'] = _priceFilter.split('-')[0];
        if (_priceFilter.isNotEmpty)
          queryParams['endMonthlyMaintenance'] = _priceFilter.split('-')[1];
        if (_bedrooms.isNotEmpty) queryParams['bedrooms'] = _bedrooms + ' BHK';
        if (bachelor.isNotEmpty) queryParams['bachelors'] = bachelor;
        if (listedBy.isNotEmpty) queryParams['listedBy'] = listedBy;
        if (area.isNotEmpty) queryParams['carpetArea'] = area;
        if (sort.isNotEmpty) queryParams['sortBy'] = sort;
        if (_furnished.isNotEmpty) queryParams['furnished'] = _furnished;
        if (_categoryType.isNotEmpty)
          queryParams['CategoryType'] = _categoryType;
      } else {
        // No filters, fetch all properties
        url =
            'http://10.0.2.2:8000/api/rooms?city=${tokenController.address.value}';
      }

      // Construct URI with query parameters
      final uri = Uri.parse(url)
          .replace(queryParameters: hasFilters ? queryParams : null);

      // Make the HTTP GET request
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        final List properties =
            hasFilters ? jsonResponse['data'] : jsonResponse;
        print(properties);
        setState(() {
          _properties = properties
              .map((data) =>
                  Property.fromJson(data['room'])) // Explicitly extract 'room'
              .toList();
          _user = properties
              .map((data) =>
                  User.fromJson(data['user'])) // Explicitly extract 'room'
              .toList();
        });
      } else {
        print('Error: ${response.statusCode} - ${response.reasonPhrase}');
        setState(() {
          _properties = [];
        });
      }
    } catch (e) {
      print('Error fetching properties: $e');
      setState(() {
        _properties = [];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _applyFilters(Map<String, dynamic> filters) {
    setState(() {
      _priceFilter = filters['Price Range'] ?? '';
      _bedrooms = filters['Bedrooms'] ?? '';
      _categoryType = filters['Category'] ?? '';
      bachelor = filters['Bachelor Allowance'] ?? '';
      listedBy = filters['Listed by'] ?? '';
      sort = filters['Sort by'] ?? '';
      print(sort);
      area = filters['Square Build-Up Area'] ?? '';
      _furnished = filters['Furnished'] ?? '';
    });

    fetchProperties();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onSearch: (query) {
          setState(() {
            _searchQuery = query; // Set search query
          });
          if (_searchQuery == '') {
            fetchProperties();
          }
          SearchProperties();
          // Fetch properties based on search query
        },
        IsSort: true,
        context: context,
      ),
      body: _isLoading
          ? Center(
              child: SizedBox(
                height: 500,
                child: Image.asset(
                  'assets/images/loading.gif',
                  width: 165,
                ),
              ),
            )
          : _properties.isEmpty
              ? Center(child: Text('No properties found'))
              : SingleChildScrollView(
                  child: ListingList(
                    properties: _properties,
                    users: _user,
                  ),
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

class ListingList extends StatelessWidget {
  final List<Property> properties;
  final List<User> users;

  const ListingList({required this.properties, required this.users});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: properties.length,
      itemBuilder: (context, index) {
        return ListingCard(
          property: properties[index],
          user: users[index],
        );
      },
    );
  }
}

class ListingCard extends StatefulWidget {
  final Property property;
  final User user;

  const ListingCard({required this.property, required this.user});

  @override
  State<ListingCard> createState() => _ListingCardState();
}

class _ListingCardState extends State<ListingCard> {
  bool isInWishlist = false;

  Future<void> CheckWishlist() async {
    bool inWishlist =
        await ApiFunctionsGet().checkWishlistStatus(widget.property.uid);
    setState(() {
      isInWishlist = inWishlist;
    });
    print('Property is in wishlist: $isInWishlist');
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
            return FlatDetailsPage(
              user: widget.user,
              property: widget.property,
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
                    image: widget.property.image.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(widget.property.image[0]),
                            fit: BoxFit.fill)
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
                              widget.property.title.length > 20
                                  ? widget.property.title.substring(0, 18)
                                  : widget
                                      .property.title, // limit to 20 characters
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
                                        .toggleWishlist(widget.property.uid);
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
                        'INR: ${widget.property.price}',
                        style: GoogleFonts.poppins(
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.only(right: 25.0),
                        child: Text(
                          widget.property.description.toString(),
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
                                widget.property.location,
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
                              '${DateFormat('dd-MM-yyyy').format(DateTime.parse(widget.property.createdAt.toString()))}',
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
        if (widget.property.featureListing)
          Positioned(
            top: -25,
            left: 8,
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                  padding: const EdgeInsets.only(left: 1.2, top: 1.2),
                  child: Image.asset(
                    'assets/images/Featured.png',
                    width: 90,
                    // height: 20,
                  )),
            ),
          )
      ]),
    );
  }
}
