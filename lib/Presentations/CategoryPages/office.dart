import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
// Create OfficeDetail page
import 'dart:convert';
import '../../ApiServices/GetApis.dart';
import '../../Components/customAppbar.dart';
import 'package:http/http.dart' as http;

import '../../FilterWidget.dart';
import '../../GetX/TokenController.dart';
import '../../Models/Office.dart';
import '../../Models/User.dart';
import 'BhojanalayCategory.dart';
import '../DetailsPage/OfficeDetailsPage.dart';

class OfficeCategoryPage extends StatefulWidget {
  @override
  State<OfficeCategoryPage> createState() => _OfficeCategoryPageState();
}

class _OfficeCategoryPageState extends State<OfficeCategoryPage> {
  List<Office> _offices = [];
  List<User> _user = [];
  bool _isLoading = true;
  final TokenController tokenController = Get.find();
  // Filter parameters
  String _sort = '';
  String _budget = '';
  String _listedby = '';
  String _furnished = '';
  String _area = '';

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
    'Furnished': ["Fully Furnished", "Semi Furnished", "Unfurnished"],
    'Build-up Area': ['Male', 'Female'],
  };

  @override
  void initState() {
    super.initState();
    fetchOffices(); // Fetch all offices initially
  }

  String _searchQuery = '';
  Future<void> SearchOffice() async {
    String url;
    url = 'http://10.0.2.2:8000/api/search-offices?q=${_searchQuery}';
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
        final List offices = jsonResponse['data'];
        setState(() {
          _offices = offices
              .map((data) =>
                  Office.fromJson(data['office'])) // Explicitly extract 'room'
              .toList();
          _user = offices
              .map((data) =>
                  User.fromJson(data['user'])) // Explicitly extract 'room'
              .toList();
        });
      } else {
        print('Error: ${response.statusCode} - ${response.reasonPhrase}');
        setState(() {
          _offices = [];
        });
      }
    } catch (e) {
      print('Error fetching properties: $e');
      setState(() {
        _offices = [];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> fetchOffices() async {
    setState(() {
      _isLoading = true;
    });

    String url;
    Map<String, String> queryParams = {};

    try {
      bool hasFilters = _budget.isNotEmpty ||
          _listedby.isNotEmpty ||
          _sort.isNotEmpty ||
          _area.isNotEmpty ||
          _furnished.isNotEmpty;

      if (hasFilters) {
        // Use filtered endpoint
        url = 'http://10.0.2.2:8000/api/filter-offices';

        // Add filter parameters
        if (_budget.isNotEmpty)
          queryParams['minMonthly'] = _budget.split('-')[0];
        if (_budget.isNotEmpty)
          queryParams['maxMonthly'] = _budget.split('-')[1];
        if (_listedby.isNotEmpty) queryParams['ListedBy'] = _listedby;
        if (_sort.isNotEmpty) queryParams['sortBy'] = _sort;
        if (_area.isNotEmpty)
          queryParams['CarpetAreaMin'] = _area.split('-')[0];
        if (_area.isNotEmpty)
          queryParams['CarpetAreaMax'] = _area.split('-')[1];
        if (_furnished.isNotEmpty) queryParams['Furnished'] = _furnished;
      } else {
        // Fetch all offices
        url =
            'http://10.0.2.2:8000/api/office-listings?city=${tokenController.address.value}';
      }

      final uri = Uri.parse(url)
          .replace(queryParameters: hasFilters ? queryParams : null);

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        print(response.body);
        final jsonResponse = json.decode(response.body);
        final List offices = hasFilters ? jsonResponse['data'] : jsonResponse;

        setState(() {
          _offices = offices
              .map((data) =>
                  Office.fromJson(data['office'])) // Explicitly extract 'room'
              .toList();
          _user = offices
              .map((data) =>
                  User.fromJson(data['user'])) // Explicitly extract 'room'
              .toList();
        });
      } else {
        setState(() {
          _offices = [];
        });
      }
    } catch (e) {
      setState(() {
        _offices = [];
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
      _area = filters['Build-up Area'] ?? '';
      print(_sort);
      print(_area);
      print(_area);
      _furnished = filters['Furnished'] ?? '';
    });

    fetchOffices();
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
              fetchOffices();
            }
            SearchOffice();
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
            : _offices.isEmpty
                ? Center(child: Text('No offices found'))
                : SingleChildScrollView(
                    child: OfficeListingList(
                      office: _offices,
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
        ));
  }
}

class OfficeListingList extends StatelessWidget {
  final List<Office> office;
  final List<User> user;

  const OfficeListingList({required this.office, required this.user});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: office.length,
      itemBuilder: (context, index) {
        return OfficeListingCard(
          office: office[index],
          user: user[index],
        );
      },
    );
  }
}

class OfficeListingCard extends StatefulWidget {
  final Office office;
  final User user;

  const OfficeListingCard({required this.office, required this.user});

  @override
  State<OfficeListingCard> createState() => _OfficeListingCard();
}

class _OfficeListingCard extends State<OfficeListingCard> {
  bool isInWishlist = false;

  Future<void> CheckWishlist() async {
    bool inWishlist =
        await ApiFunctionsGet().checkWishlistStatus(widget.office.officeId);
    setState(() {
      isInWishlist = inWishlist;
    });
    print('office is in wishlist: $isInWishlist');
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
            return OfficeDetailPage(
              user: widget.user,
              office: widget.office,
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
                    image: widget.office.image.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(widget.office.image[0]),
                            fit: BoxFit.fill)
                        : null,
                    // color: Colors.red,
                    borderRadius: BorderRadius.circular(10),

                    // Add image fetching logic here if office image are available
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
                              widget.office.title.length > 20
                                  ? widget.office.title.substring(0, 18)
                                  : widget
                                      .office.title, // limit to 20 characters
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
                                        .toggleWishlist(widget.office.officeId);
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
                        'INR: ${widget.office.officeMonthlyMaintenance}',
                        style: GoogleFonts.poppins(
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.only(right: 25.0),
                        child: Text(
                          widget.office.officeDescription.toString(),
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
                                widget.office.location,
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
                              '${DateFormat('dd-MM-yyyy').format(DateTime.parse(widget.office.createdAt.toString()))}',
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
        if (widget.office.featureListing)
          Positioned(
            top: -25,
            left: 8,
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 1.2, top: 1.2),
                child: widget.office.featureListing == false
                    ? Image.asset(
                        'assets/images/Featured.png',
                        width: 90,
                        // height: 20,
                      )
                    : SizedBox(),
              ),
            ),
          )
      ]),
    );
  }
}
