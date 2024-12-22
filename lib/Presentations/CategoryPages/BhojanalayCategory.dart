import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:maan/GetX/TokenController.dart';

import '../../ApiServices/GetApis.dart';
import '../../Components/customAppbar.dart';
import '../../FilterWidget.dart';
import '../../Models/Bhojanalya.dart';
import '../../Models/User.dart';
import '../DetailsPage/BhojnalayaDetailPage.dart';

class BhojanalyaCategoryPage extends StatefulWidget {
  @override
  State<BhojanalyaCategoryPage> createState() => _BhojanalyaCategoryPageState();
}

class _BhojanalyaCategoryPageState extends State<BhojanalyaCategoryPage> {
  List<Bhojnalaya> _bhojnalayaList = [];
  List<User> _user = [];
  List<Bhojnalaya> _searchResults = [];
  bool _isSearching = false;
  bool _isLoading = true;
  final TokenController tokenController = Get.find();
  String _vegOrNonVeg = '';
  String _timings = '';
  String _parcel = '';
  String _monthly1 = '';
  String _monthly2 = '';
  String _sort = '';
  String _priceofthali = '';
  bool _isApproved = false;

  @override
  void initState() {
    super.initState();
    fetchBhojnalaya();
  }

  final Map<String, List<String>> _filterOptions = {
    // 'Price Range': ['0-5000', '5000-10000', '10000-15000', '15000+'],
    'Monthly Thali Charge 1 Time': [
      '0-5000',
      '5000-10000',
      '10000-15000',
      '15000+'
    ],
    'Monthly Thali Charge 2 Time': [
      '0-5000',
      '5000-10000',
      '10000-15000',
      '15000+'
    ], // Price Range options
    'Parcel Of Food': ['Yes', 'No'],
    'Sort by': [
      'Price : Low to High ',
      'Price : High to Low',
      'Recent Listings'
    ],
    'Timings': ['8 to 12', '12 to 6'],
    'Veg/Non-Veg': ['Veg', 'Non -Veg'],
    'Price Of Thali': ['500', '1000', '1500'],
  };

  String _searchQuery = '';
  Future<void> SearchBhojnalaya() async {
    String url;
    url = 'http://10.0.2.2:8000/api/filter-bhojnalayas?q=${_searchQuery}';
    try {
      final uri = Uri.parse(url);

      // Make the HTTP GET request
      final response = await http.get(uri);
      print("-------------------------");
      print(response.body);
      print("-------------------------");
      print(response.statusCode);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print(response.body);
        // Parse properties based on the response structure
        final List properties = jsonResponse['data'];
      } else {
        print('Error: ${response.statusCode} - ${response.reasonPhrase}');
        setState(() {
          _bhojnalayaList = [];
        });
      }
    } catch (e) {
      print('Error fetching properties: $e');
      setState(() {
        _bhojnalayaList = [];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> fetchBhojnalaya() async {
    setState(() {
      _isLoading = true;
    });

    String url;
    Map<String, String> queryParams = {};

    try {
      // Determine if any filters or search query are applied
      bool hasFilters = _priceofthali.isNotEmpty ||
          _sort.isNotEmpty ||
          _parcel.isNotEmpty ||
          _monthly1.isNotEmpty ||
          _monthly2.isNotEmpty ||
          _vegOrNonVeg.isNotEmpty ||
          _timings.isNotEmpty ||
          (!_isApproved);

      if (!hasFilters) {
        // Use the search endpoint
        url = 'http://10.0.2.2:8000/api/filter-bhojnalayas';

        // Add search query and filter parameters
        if (_priceofthali.isNotEmpty)
          queryParams['minPriceOfThali'] = _priceofthali.split('-')[0];
        if (_priceofthali.isNotEmpty)
          queryParams['maxPriceOfThali'] = _priceofthali.split('-')[1];
        if (_timings.isNotEmpty) queryParams['timings'] = _timings;
        if (_monthly1.isNotEmpty) queryParams['monthlyCharge1'] = _monthly1;
        if (_monthly2.isNotEmpty) queryParams['monthlyCharge2'] = _monthly2;
        if (_sort.isNotEmpty) queryParams['sortBy'] = _sort;
        if (_parcel.isNotEmpty) queryParams['parcelOfFood'] = _parcel;
        if (_vegOrNonVeg.isNotEmpty) queryParams['veg'] = _vegOrNonVeg;
        if (_isApproved != null)
          queryParams['isApproved'] = _isApproved.toString();
      } else {
        // No filters, fetch all properties
        url =
            'http://10.0.2.2:8000/api/bhojnalayas?city=${tokenController.address}';
      }

      // Construct URI with query parameters
      print(url);
      final uri = Uri.parse(url)
          .replace(queryParameters: hasFilters ? queryParams : null);

      // Make the HTTP GET request
      final response = await http.get(uri);
      print(response.statusCode);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final List properties =
            hasFilters ? jsonResponse : jsonResponse['data'];
        setState(() {
          _bhojnalayaList = properties
              .map((data) => Bhojnalaya.fromJson(
                  data['bhojnalaya'])) // Explicitly extract 'room'
              .toList();
          _user = properties
              .map((data) =>
                  User.fromJson(data['user'])) // Explicitly extract 'room'
              .toList();
        });
      } else {
        print('Error: ${response.statusCode} - ${response.reasonPhrase}');
        setState(() {
          _bhojnalayaList = [];
        });
      }
    } catch (e) {
      print('Error fetching properties: $e');
      setState(() {
        _bhojnalayaList = [];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _applyFilters(Map<String, dynamic> filters) {
    setState(() {
      _priceofthali = filters['Budget'] ?? '';
      _parcel = filters['Parcel Of Food'] ?? '';
      _monthly1 = filters['Monthly Thali Charge 1 Time'] ?? '';
      _monthly2 = filters['Monthly Thali Charge 2 Time'] ?? '';
      _vegOrNonVeg = filters['veg/Non-Veg'] ?? '';
      _sort = filters['Sort by'] ?? '';
      print(_sort);
      _timings = filters['Timings'] ?? '';
      _priceofthali = filters['Price Of Thali'] ?? '';
    });

    fetchBhojnalaya();
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
            fetchBhojnalaya();
          }
          SearchBhojnalaya();
          // Fetch properties based on search query
        },
        IsSort: false,
        context: context,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (_isSearching)
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  return BhojnalayaCard(
                      bhojnalaya: _searchResults[index], user: _user[index]);
                },
              ),
            if (_isLoading)
              Center(
                child: SizedBox(
                  height: 500,
                  child: Image.asset(
                    'assets/images/loading.gif',
                    width: 165,
                  ),
                ),
              ),
            if (!_isLoading)
              _bhojnalayaList.isEmpty
                  ? Center(child: Text('No Bhojnalayas found'))
                  : ListingList(
                      bhojnalaya: _bhojnalayaList,
                      user: _user,
                    ),
          ],
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
  final List<Bhojnalaya> bhojnalaya;
  final List<User> user;

  const ListingList({required this.bhojnalaya, required this.user});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: bhojnalaya.length,
      itemBuilder: (context, index) {
        return BhojnalayaCard(
          bhojnalaya: bhojnalaya[index],
          user: user[index],
        );
      },
    );
  }
}

class BhojnalayaCard extends StatefulWidget {
  final Bhojnalaya bhojnalaya;
  final User user;

  const BhojnalayaCard({required this.bhojnalaya, required this.user});

  @override
  State<BhojnalayaCard> createState() => _BhojnalayaCard();
}

class _BhojnalayaCard extends State<BhojnalayaCard> {
  bool isInWishlist = false;

  Future<void> CheckWishlist() async {
    bool inWishlist =
        await ApiFunctionsGet().checkWishlistStatus(widget.bhojnalaya.id);
    setState(() {
      isInWishlist = inWishlist;
    });
    print('bhojnalaya is in wishlist: $isInWishlist');
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
            return BhojnalayaDetailPage(
              user: widget.user,
              bhojnalaya: widget.bhojnalaya,
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
                    image: widget.bhojnalaya.image.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(widget.bhojnalaya.image[0]),
                            fit: BoxFit.fill)
                        : null,
                    // color: Colors.red,
                    borderRadius: BorderRadius.circular(10),

                    // Add image fetching logic here if bhojnalaya image are available
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
                              widget.bhojnalaya.title.length > 20
                                  ? widget.bhojnalaya.title.substring(0, 18)
                                  : widget.bhojnalaya
                                      .title, // limit to 20 characters
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
                                        .toggleWishlist(widget.bhojnalaya.id);
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
                        'INR: ${widget.bhojnalaya.price}',
                        style: GoogleFonts.poppins(
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.only(right: 25.0),
                        child: Text(
                          widget.bhojnalaya.description.toString(),
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
                                widget.bhojnalaya.location,
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
                              '${DateFormat('dd-MM-yyyy').format(DateTime.parse(widget.bhojnalaya.createdAt.toString()))}',
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
        if (widget.bhojnalaya.featureListing)
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
