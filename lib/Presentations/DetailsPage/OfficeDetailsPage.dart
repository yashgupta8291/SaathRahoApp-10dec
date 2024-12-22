import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Components/AmenitiesComponent.dart';
import '../../Components/bottomNav.dart';
import '../../Components/detailRow.dart';
import '../../Models/Office.dart';
import '../../Models/User.dart';
import '../ChatPages/chatscreen.dart';
import '../../ApiServices/GetApis.dart';
import '../../Components/CustomButton2.dart';

// Pass the Office object as a parameter to this widget.
class OfficeDetailPage extends StatefulWidget {
  final Office office;
  final User? user;

  const OfficeDetailPage({super.key, required this.office, required this.user});

  @override
  State<OfficeDetailPage> createState() => _OfficeDetailPageState();
}

class _OfficeDetailPageState extends State<OfficeDetailPage> {
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
    print(widget.office.userUid);
    CheckWishlist();
    setState(() {});
  }

  Future<void> CheckWishlist() async {
    bool inWishlist =
        await ApiFunctionsGet().checkWishlistStatus(widget.office.officeId);
    setState(() {
      isInWishlist = inWishlist;
    });
    print('office is in wishlist: $isInWishlist');
  }
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final office = widget.office;
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
                await ApiFunctionsGet().toggleWishlist(widget.office.officeId);
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
                    items: office.image.map((imageUrl) {
                      return Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(imageUrl),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(
                              screenWidth * 0.05), // Responsive corner radius
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
                        borderRadius: BorderRadius.circular(
                            screenWidth * 0.02), // Responsive corner radius
                      ),
                      child: Text(
                        "${currentImageIndex + 1} / ${office.image.length}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.035, // Responsive font size
                        ),
                      ),
                    ),
                  ),
                  if (widget.office.featureListing)
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
                          child: widget.office.featureListing == false
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
            // office info
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
                      "INR ${office.officeMonthlyMaintenance}/-",
                      style: titleStyle.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(office.title, style: detailStyle),
                    // Text(office.title, style: detailStyle),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          office.location,
                          style: GoogleFonts.poppins(fontSize: 11),
                        ),
                        Text(
                          style: GoogleFonts.poppins(fontSize: 11),
                          DateFormat('yyyy-MM-dd').format(
                              DateTime.parse(office.createdAt.toString())),
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
                  amenities = office.amenities!;
                },
                propertyAmenities: office.amenities!,
              ),
            ),
            // office details
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
                        "City", office.city + '-' + widget.office.pincode),
                    detailRow("Furnished", office.furnished),
                    detailRow(
                        "Monthly maintenance", office.price),
                    detailRow("Carpet Area", office.carpetArea),
                    detailRow("Floor", office.officeFloorNo),
                    detailRow("Total Floors", office.officeTotalFloor),
                    detailRow("Facing", office.officeFacing),
                    detailRow("Cabins", office.noOfCabins),
                    detailRow("Deposit", office.officeDeposit),
                    detailRow("Bathrooms", office.noOfBathrooms),
                    detailRow("Parking", office.parkingAvailable),
                    // Add more details as required...
                  ],
                ),
              ),
            ),
            // office description
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
                      widget.office.officeDescription.toString(),
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
      bottomNavigationBar: office.userUid != myId
          ? BottomNavBarWithRoundCorners(
              user: widget.user!,
              location: office.location,
              picture: widget.user!.picture,
              Targetid: widget.user!.uid,
            )
          : null,
    );
  }
}
