import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Components/AmenitiesComponent.dart';
import '../../Components/bottomNav.dart';
import '../../Components/detailRow.dart';
import '../../Models/Hostel.dart';
import '../../Models/User.dart';
import '../ChatPages/chatscreen.dart';
import '../../ApiServices/GetApis.dart';
import '../../Components/CustomButton2.dart';

class HostelDetailPage extends StatefulWidget {
  final Hostel hostel;
  final User? user;

  const HostelDetailPage(
      {super.key, required this.hostel, required this.user});

  @override
  State<HostelDetailPage> createState() => _HostelDetailPageState();
}

class _HostelDetailPageState extends State<HostelDetailPage> {
  final double paddingSize = 8.0;
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
    print(widget.hostel.id);
    CheckWishlist();
    setState(() {});
  }

  Future<void> CheckWishlist() async {
    bool inWishlist =
    await ApiFunctionsGet().checkWishlistStatus(widget.hostel.id);
    setState(() {
      isInWishlist = inWishlist;
    });
    print('hostel is in wishlist: $isInWishlist');
  }
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final hostel = widget.hostel;
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
                await ApiFunctionsGet().toggleWishlist(widget.hostel.id);
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
                    items: hostel.image.map((imageUrl) {
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
                        "${currentImageIndex + 1} / ${hostel.image.length}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.035, // Responsive font size
                        ),
                      ),
                    ),
                  ),
                  if (widget.hostel.featureListing)
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
                          child:Image.asset(
                            'assets/images/Featured.png',
                            width: screenWidth * 0.25, // Responsive width
                          )
                        ),
                      ),
                    ),
                ],
              ),
            ),

            SizedBox(height: 10),
            // hostel info
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
                      "INR ${hostel.rent}/-",
                      style: titleStyle.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(hostel.title, style: detailStyle),
                    // Text(hostel.title, style: detailStyle),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          hostel.location,
                          style: GoogleFonts.poppins(fontSize: 11),
                        ),
                        Text(
                          style: GoogleFonts.poppins(fontSize: 11),
                          DateFormat('yyyy-MM-dd').format(
                              DateTime.parse(hostel.createdAt.toString())),
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
                  amenities = hostel.amenities!;
                },
                propertyAmenities: hostel.amenities!,
              ),
            ),
            // hostel details
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
                        "City", hostel.city + '-' + widget.hostel.pincode),
                    detailRow("Bathrooms", hostel.bathrooms),
                    detailRow("Furnished", hostel.furnished),
                    detailRow("Location", hostel.location),
                    detailRow("Visitors allowed", hostel.visitorsAllowed),
                    detailRow("Deposit", hostel.deposit),
                    detailRow("Dine in", hostel.diningFacility),
                    detailRow("Carpet Area", hostel.categoryOfPeople),
                    detailRow("Bachelor’s Allowed", hostel.title.toString()),
                    detailRow("Total Floors", hostel.electricity),
                    detailRow("Floor No", hostel.totalFloors),
                    detailRow("Parking", hostel.parking),
                    detailRow("Facing", hostel.furnished),
                    detailRow("Advance Amount", hostel.price.toString()),
                    detailRow("Monthly Maintainace", hostel.price.toString()),
                    detailRow("Category", hostel.sharing),
                    // Add more details as required...
                  ],
                ),
              ),
            ),
            // hostel description
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
                      widget.hostel.description.toString(),
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
      bottomNavigationBar: hostel.id != myId
          ? BottomNavBarWithRoundCorners(
        user: widget.user!,
        location: hostel.location,
        picture: widget.user!.picture,
        Targetid: widget.user!.uid,
      )
          : null,
    );
  }
}
