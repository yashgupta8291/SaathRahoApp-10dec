import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../ApiServices/GetApis.dart';
import '../../Components/AmenitiesComponent.dart';
import '../../Components/detailRow.dart';
import '../../Models/Property.dart';
import '../../Components/CustomButton2.dart';
import '../../Components/bottomNav.dart';
import '../../Models/User.dart';

class FlatDetailsPage extends StatefulWidget {
  final Property property;
  final User? user;

  const FlatDetailsPage(
      {super.key, required this.property, required this.user});

  @override
  State<FlatDetailsPage> createState() => _FlatDetailsPageState();
}

class _FlatDetailsPageState extends State<FlatDetailsPage> {

  bool isInWishlist = false;
  String myId = '';

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    myId = (await ApiFunctionsGet().getUserId())!;
    print(myId);
    print(widget.property.uid);
    CheckWishlist();
    setState(() {});
  }

  Future<void> CheckWishlist() async {
    bool inWishlist =
        await ApiFunctionsGet().checkWishlistStatus(widget.property.uid);
    setState(() {
      isInWishlist = inWishlist;
    });
    print('Property is in wishlist: $isInWishlist');
  }


  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final property = widget.property;
    int currentImageIndex = 0;

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.share)),
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: IconButton(
              onPressed: () async {
                await ApiFunctionsGet().toggleWishlist(widget.property.uid);
                CheckWishlist(); // Refresh the wishlist status
              },
              icon: Icon(
                isInWishlist ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                color: isInWishlist ? Colors.red : Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Image carousel
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.01), // Responsive padding
              child: Stack(
                children: [
                  CarouselSlider(
                    items: property.image.map((imageUrl) {
                      return Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(imageUrl),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(screenWidth * 0.05), // Responsive corner radius
                        ),
                        width: screenWidth,
                        height: screenWidth * 0.5,
                      );
                    }).toList(),
                    options: CarouselOptions(
                      height: screenWidth * 0.5, // Responsive height
                      viewportFraction: 1.0,
                      onPageChanged: (index, reason) {
                        setState(() {
                          currentImageIndex = index;
                        });
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.02,
                        vertical: screenWidth * 0.01,
                      ), // Responsive padding
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(screenWidth * 0.02), // Responsive corner radius
                      ),
                      child: Text(
                        "${currentImageIndex + 1} / ${property.image.length}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.035, // Responsive font size
                        ),
                      ),
                    ),
                  ),
                  if (widget.property.featureListing)
                    Positioned(
                      top: screenWidth * -0.11, // Adjusted for responsiveness
                      left: screenWidth * -0.02,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: screenWidth * 0.005,
                            top: screenWidth * 0.005,
                          ), // Responsive padding
                          child: widget.property.featureListing == false
                              ? Image.asset(
                            'assets/images/Featured.png',
                            width: screenWidth * 0.25, // Responsive width
                          )
                              : SizedBox(),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            SizedBox(height: 10),
            // Property info
            Padding(
              padding: EdgeInsets.all(12),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.all(paddingSize),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "INR ${property.price}/-",
                      style: titleStyle.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(property.title, style: detailStyle),
                    // Text(property.title, style: detailStyle),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          property.location,
                          style: GoogleFonts.poppins(fontSize: 11),
                        ),
                        Text(
                          style: GoogleFonts.poppins(fontSize: 11),
                          DateFormat('yyyy-MM-dd').format(
                              DateTime.parse(property.createdAt.toString())),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Amenities
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: PropertyAmenties(
                onSelectedAmenitiesChanged: (List<String> amenities) {
                  amenities = property.amenities!;
                },
                propertyAmenities: property.amenities!,
              ),
            ),
            // Property details
            Padding(
              padding: EdgeInsets.all(paddingSize),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.only(left: paddingSize, right: paddingSize),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Details",
                        style: titleStyle.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(height: 10),
                    detailRow(
                        "City", property.city + '-' + widget.property.pincode),
                    detailRow("Bedrooms", property.bedrooms),
                    detailRow("Bathrooms", property.bathroom),
                    detailRow("Furnished", property.furnished),
                    detailRow("Listed By", property.listedBy),
                    detailRow("Carpet Area", property.carpetArea),
                    detailRow(
                        "Bachelor’s Allowed", property.bedrooms.toString()),
                    detailRow("Total Floors", property.totalFloor),
                    detailRow("Floor No", property.floorNo),
                    detailRow("Parking", property.parking),
                    detailRow("Facing", property.facing),
                    detailRow("Advance Amount", property.advance.toString()),
                    detailRow("Category", property.categoryOfPeople),
                    // Add more details as required...
                  ],
                ),
              ),
            ),
            // Property description
            Padding(
              padding: EdgeInsets.all(paddingSize),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.all(paddingSize),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Description :',
                      softWrap: true,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.property.description.toString(),
                      softWrap: true,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w300,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: property.uid != myId
          ? BottomNavBarWithRoundCorners(
              user: widget.user!,
              location: property.location,
              picture: widget.user!.picture,
              Targetid: widget.user!.uid,
            )
          : null,
    );
  }
}
