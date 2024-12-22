import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../ApiServices/GetApis.dart';
import '../../Components/customAppbar.dart';
import '../../FilterWidget.dart';
import '../../GetX/TokenController.dart';
import '../../Models/Hostel.dart';
import '../../Models/User.dart';
import 'BhojanalayCategory.dart';
import '../DetailsPage/HostelDetailPage.dart';

class HostelCategoryPage extends StatefulWidget {
  @override
  State<HostelCategoryPage> createState() => _HostelCategoryPageState();
}

class _HostelCategoryPageState extends State<HostelCategoryPage> {
  List<Hostel> _hostels = [];
  bool _isLoading = true;
  List<User> _user = [];
  final TokenController tokenController = Get.find();
  String _sort = '';
  String _budget = '';
  String _listedby = '';
  String _gender = '';

  final Map<String, List<String>> _filterOptions = {
    // 'Price Range': ['0-5000', '5000-10000', '10000-15000', '15000+'],
    'Budget': [
      '0-5000',
      '5000-10000',
      '10000-15000',
      '15000+'
    ], // Price Range options
    'Listed By': ['Owner', 'Rental'],
    'Sort by': [
      'Price : Low to High ',
      'Price : High to Low',
      'Recent Listings'
    ],
    'Gender Preference': ['Male', 'Female'],
  };

  @override
  void initState() {
    super.initState();
    fetchHostels(); // Fetch all hostels initially
  }

  String _searchQuery = '';
  Future<void> SearchHostels() async {
    String url;
    url = 'http://10.0.2.2:8000/api/search-hostels?q=${_searchQuery}';
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
        final List hostel = jsonResponse['data'];

        setState(() {
          _hostels = hostel
              .map((data) =>
                  Hostel.fromJson(data['hostel'])) // Explicitly extract 'room'
              .toList();
          _user = hostel
              .map((data) =>
                  User.fromJson(data['user'])) // Explicitly extract 'room'
              .toList();
        });
      } else {
        print('Error: ${response.statusCode} - ${response.reasonPhrase}');
        setState(() {
          _hostels = [];
        });
      }
    } catch (e) {
      print('Error fetching properties: $e');
      setState(() {
        _hostels = [];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> fetchHostels() async {
    setState(() {
      _isLoading = true;
    });

    String url;
    Map<String, String> queryParams = {};

    try {
      bool hasFilters = _budget.isNotEmpty ||
          _sort.isNotEmpty ||
          _gender.isNotEmpty ||
          _listedby.isNotEmpty;

      if (hasFilters) {
        // Use filtered endpoint
        url = 'http://10.0.2.2:8000/api/filter-hostels';

        // Add filter parameters
        if (_gender.isNotEmpty) queryParams['gender'] = _gender;
        if (_budget.isNotEmpty) queryParams['rentMin'] = _budget.split('-')[0];
        if (_budget.isNotEmpty) queryParams['rentMax'] = _budget.split('-')[1];
        if (_sort.isNotEmpty) queryParams['sortBy'] = _sort;
        // if (_listedby.isNotEmpty) queryParams['sortBy'] = _listedby;
      } else {
        // Fetch all offices
        url =
            'http://10.0.2.2:8000/api/hostels?city=${tokenController.address.value}';
      }

      final uri = Uri.parse(url)
          .replace(queryParameters: hasFilters ? queryParams : null);

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        // print(response.body);
        final jsonResponse = json.decode(response.body);
        final List hostel = hasFilters ? jsonResponse['data'] : jsonResponse;

        print(hostel[0]['hostels']);

        setState(() {
          _hostels = hostel
              .map((data) =>
                  Hostel.fromJson(data['hostels'])) // Explicitly extract 'room'
              .toList();
          _user = hostel
              .map((data) =>
                  User.fromJson(data['user'])) // Explicitly extract 'room'
              .toList();
        });
      } else {
        setState(() {
          _hostels = [];
        });
      }
    } catch (e) {
      setState(() {
        _hostels = [];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _applyFilters(Map<String, dynamic> filters) {
    setState(() {
      _budget = filters['Budget'] ?? '';
      _listedby = filters['Listed By'] ?? '';
      _sort = filters['Sort By'] ?? '';
      _gender = filters['Gender Preference'] ?? '';
      print(_sort);
    });

    fetchHostels();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onSearch: (query) {
          setState(() {
            _searchQuery = query;
          });
          SearchHostels();
          if (_searchQuery == '') {
            fetchHostels();
          }
          setState(() {});
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
          : _hostels.isEmpty
              ? Center(child: Text('No hostels found'))
              : SingleChildScrollView(
                  child: ListingList(
                    hostels: _hostels,
                    user: _user,
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
  final List<Hostel> hostels;
  final List<User> user;

  const ListingList({required this.hostels, required this.user});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: hostels.length,
      itemBuilder: (context, index) {
        return HostelCard(hostel: hostels[index], user: user[index]);
      },
    );
  }
}

class HostelCard extends StatefulWidget {
  final Hostel hostel;
  final User user;

  const HostelCard({required this.hostel, required this.user});

  @override
  State<HostelCard> createState() => _HostelCard();
}

class _HostelCard extends State<HostelCard> {
  bool isInWishlist = false;

  Future<void> CheckWishlist() async {
    bool inWishlist =
        await ApiFunctionsGet().checkWishlistStatus(widget.hostel.id);
    setState(() {
      isInWishlist = inWishlist;
    });
    print('hostel is in wishlist: $isInWishlist');
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
            return HostelDetailPage(
              user: widget.user,
              hostel: widget.hostel,
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
                    image: widget.hostel.image.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(widget.hostel.image[0]),
                            fit: BoxFit.fill)
                        : null,
                    // color: Colors.red,
                    borderRadius: BorderRadius.circular(10),

                    // Add image fetching logic here if hostel image are available
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
                              widget.hostel.title.length > 20
                                  ? widget.hostel.title.substring(0, 18)
                                  : widget
                                      .hostel.title, // limit to 20 characters
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
                                        .toggleWishlist(widget.hostel.id);
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
                        'INR: ${widget.hostel.rent}',
                        style: GoogleFonts.poppins(
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.only(right: 25.0),
                        child: Text(
                          widget.hostel.description.toString(),
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
                                widget.hostel.location,
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
                              '${DateFormat('dd-MM-yyyy').format(DateTime.parse(widget.hostel.createdAt.toString()))}',
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
        if (widget.hostel.featureListing)
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
