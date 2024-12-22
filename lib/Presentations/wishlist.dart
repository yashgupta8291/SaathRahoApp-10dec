import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maan/Models/Bhojanalya.dart';
import 'package:maan/Presentations/DetailsPage/BhojnalayaDetailPage.dart';
import 'package:maan/Presentations/DetailsPage/HostelDetailPage.dart';
import 'package:maan/Presentations/DetailsPage/OfficeDetailsPage.dart';
import 'package:maan/Presentations/DetailsPage/RommateDetail.dart';
import 'dart:convert';
import '../ApiServices/ApiServices.dart';
import '../ApiServices/GetApis.dart';
import '../Models/Property.dart';
import '../Models/Office.dart';
import '../Models/Hostel.dart';
import '../Models/User.dart';
import '../Models/roomate.dart';
import 'DetailsPage/FlatRoomDetailsPage.dart';

class WishlistPage extends StatefulWidget {
  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  List<Property> properties = [];
  List<Office> offices = [];
  List<Hostel> hostels = [];
  List<Bhojnalaya> bhojnalaya = [];
  List<Roommate> roommates = [];
  List<User> roommatesUser = [];
  List<User> HostelUser = [];
  List<User> PropertyUser = [];
  List<User> BhojanUser = [];
  List<User> OfficeUser = [];

  late String userUid;

  Future<void> getUserWishlistProperties() async {
    print(userUid);
    final response = await http.get(
      Uri.parse('$baseUrl/wishlist/properties?userId=$userUid'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      setState(() {
        properties =
            data.map((item) => Property.fromJson(item['room'])).toList();
        PropertyUser = data.map((item) => User.fromJson(item['user'])).toList();
      });
    } else {
      throw Exception('Failed to fetch wishlist properties: ${response.body}');
    }
  }

  Future<void> getUserWishlistOffices() async {
    print(userUid);
    final response = await http.get(
      Uri.parse('$baseUrl/wishlist/offices?userId=$userUid'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      setState(() {
        offices = data.map((item) {
          return Office.fromJson(item['office']);
        }).toList();

        OfficeUser = data.map((item) {
          return User.fromJson(item['user']);
        }).toList();
      });
    } else {
      throw Exception('Failed to fetch wishlist offices: ${response.body}');
    }
  }

  Future<void> getUserWishlistHostels() async {
    final response = await http.get(
      Uri.parse('$baseUrl/wishlist/Hostels?userId=$userUid'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        hostels = data.map((item) {
          return Hostel.fromJson(item['hostel']);
        }).toList();

        HostelUser = data.map((item) {
          return User.fromJson(item['user']);
        }).toList();
      });
    } else {
      throw Exception('Failed to fetch wishlist hostels: ${response.body}');
    }
  }

  Future<void> getUserWishlistRoommates() async {
    final response = await http.get(
      Uri.parse('$baseUrl/wishlist/Roommates?userId=$userUid'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        roommates =
            data.map((item) => Roommate.fromJson(item['roommates'])).toList();
        roommatesUser =
            data.map((item) => User.fromJson(item['user'])).toList();
      });
    } else {
      throw Exception('Failed to fetch wishlist roommates: ${response.body}');
    }
  }

  Future<void> getUserWishlistBhojanalaya() async {
    final response = await http.get(
      Uri.parse('$baseUrl/wishlist/Bhojnalayas?userId=$userUid'),
      headers: {'Content-Type': 'application/json'},
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        setState(() {
          bhojnalaya = data
              .map((item) => Bhojnalaya.fromJson(item['bhojnalaya']))
              .toList();
          BhojanUser = data.map((item) => User.fromJson(item['user'])).toList();
        });
      } else {
        setState(() {
          bhojnalaya = [];
          BhojanUser = [];
        });
      }
    } else {
      throw Exception('Failed to fetch wishlist Bhojnalaya: ${response.body}');
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      userUid = (await ApiFunctionsGet().getUserId())!;
      await Future.wait([
        getUserWishlistProperties(),
        getUserWishlistOffices(),
        getUserWishlistHostels(),
        getUserWishlistRoommates(),
        getUserWishlistBhojanalaya(),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Combine all items and users into single lists
    List<dynamic> allItems = [
      ...properties,
      ...offices,
      ...hostels,
      ...roommates,
      ...bhojnalaya
    ];
    List<dynamic> allUsers = [
      ...PropertyUser,
      ...OfficeUser,
      ...HostelUser,
      ...roommatesUser,
      ...BhojanUser
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Expanded(
              child: allItems.isEmpty
                  ? Center(child: Text('No items in wishlist'))
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 0.9,
                      ),
                      itemCount: allItems.length,
                      itemBuilder: (context, index) {
                        return _buildPropertyCard(
                            allItems[index], allUsers[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyCard(dynamic item, dynamic user) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey[400]!),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  if (item is Property) {
                    return FlatDetailsPage(
                      property: item,
                      user: user,
                    );
                  }
                  if (item is Hostel) {
                    return HostelDetailPage(
                      hostel: item,
                      user: user,
                    );
                  }
                  if (item is Office) {
                    return OfficeDetailPage(
                      office: item,
                      user: user,
                    );
                  }
                  if (item is Roommate) {
                    return RoommateDetail(
                      roommate: item,
                      user: user,
                    );
                  }
                  if (item is Bhojnalaya) {
                    return BhojnalayaDetailPage(
                      bhojnalaya: item,
                      user: user,
                    );
                  }
                  return SizedBox();
                },
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 100,
                    // decoration: BoxDecoration(
                    //   image: DecorationImage(image: NetworkImage(item.image[0])),
                    //   color: Colors.grey[300],
                    //   borderRadius: BorderRadius.vertical(
                    //       top: Radius.circular(10),
                    //       bottom: Radius.circular(10)),
                    // ),
                  ),
                  Positioned(
                    top: 4,
                    right: 8,
                    child: Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4),
                    Text(
                      item.title,
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 12,
                          color: Colors.black54,
                        ),
                        SizedBox(width: 4),
                        Text(
                          item.location,
                          style: TextStyle(fontSize: 12, color: Colors.black54),
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
    );
  }
}
