import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../ApiServices/GetApis.dart';
import '../Models/Property.dart';
import '../Models/Office.dart';
import '../Models/Hostel.dart';
import '../Models/Bhojanalya.dart';
import '../ApiServices/ApiServices.dart';
import '../Models/roomate.dart';
import 'DetailsPage/FlatRoomDetailsPage.dart';
import 'DetailsPage/HostelDetailPage.dart';
import 'DetailsPage/OfficeDetailsPage.dart';
import 'DetailsPage/RommateDetail.dart';
import 'DetailsPage/BhojnalayaDetailPage.dart';

class MyListingPage extends StatefulWidget {
  @override
  _MyListingPageState createState() => _MyListingPageState();
}

class _MyListingPageState extends State<MyListingPage> {
  static const String apiUrl = 'http://10.0.2.2:8000/api/getUserData';

  List<Property> properties = [];
  List<Office> offices = [];
  List<Hostel> hostels = [];
  List<Bhojnalaya> bhojnalaya = [];
  List<Roommate> roommates = [];
  late String userUid;

  Future<void> getUserListings() async {
    try {
      userUid = (await ApiFunctionsGet().getUserId())!;
      final response = await http.get(
        Uri.parse('$apiUrl?userId=$userUid'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          properties = (data['roomData'] as List)
              .map((item) => Property.fromJson(item))
              .toList();
          offices = (data['officeListingData'] as List)
              .map((item) => Office.fromJson(item))
              .toList();
          hostels = (data['hostelDetailsData'] as List)
              .map((item) => Hostel.fromJson(item))
              .toList();
          roommates = (data['roommateData'] as List)
              .map((item) => Roommate.fromJson(item))
              .toList();
          bhojnalaya = (data['bhojnalayaData'] as List)
              .map((item) => Bhojnalaya.fromJson(item))
              .toList();
        });
      } else {
        throw Exception('Failed to fetch listings: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
      // Optionally show a message to the user
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getUserListings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Center(
              child: Text(
                'My Listings',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildSection('Properties', properties),
                  _buildSection('Offices', offices),
                  _buildSection('Hostels', hostels),
                  _buildSection('Roommates', roommates),
                  _buildSection('Bhojnalay', bhojnalaya),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<dynamic> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8),
        items.isEmpty
            ? Center(
                child: Text(
                  '',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
            : GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.9,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return _buildListingCard(items[index]);
                },
              ),
      ],
    );
  }

  Widget _buildListingCard(dynamic item) {
    return GestureDetector(
      onTap: () async {
        int num = await  ApiFunctionsGet().MyListingCount();
        print(num);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              if (item is Property) return FlatDetailsPage(property: item, user: null,);
              if (item is Hostel) return HostelDetailPage(hostel: item, user: null,);
              if (item is Office) return OfficeDetailPage(office: item, user: null,);
              if (item is Roommate) return RoommateDetail(roommate: item, user: null,);
              if (item is Bhojnalaya)
                return BhojnalayaDetailPage(bhojnalaya: item, user: null,);
              return SizedBox();
            },
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey[400]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(10),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                item.title ?? 'Listing',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                item.location ?? 'Listing',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
