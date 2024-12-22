import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maan/Presentations/CategoryPages/RoomateCategoryPage.dart';

import '../Components/HomePageComponents.dart';
import '../Constants/AppConstants.dart';
import 'Forms/ListFlatRoomsForm.dart';
import 'Forms/bhojnalaydetails.dart';
import 'Forms/hosteldetails.dart';
import 'Forms/officespace.dart';
import 'Forms/roommate.dart';

class Addlistingpage extends StatelessWidget {
  const Addlistingpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.04,
            ),
            SvgPicture.asset('assets/svgs/houseicon2.svg'),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.07,
            ),
            Text(
              "List Your Requirement",
              style: GoogleFonts.poppins(
                  fontSize: 17, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.02,
            ),
            Text(
              """Get your connection or customers today !.""",
              style: GoogleFonts.poppins(fontSize: 14),
            ),
            Text(
              """Post your needs get in your feeds.""",
              style: GoogleFonts.poppins(fontSize: 14),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.08,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ListingContainersWidget(
                    title: 'Want to list your',
                    Subtitle: 'Flat / Room?',
                    img: 'assets/images/logo.png',
                    color: AppColors.buttonColor,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return FlatRoomForm();
                        },
                      ));
                    },
                  ),
                  ListingContainersWidget(
                    title: 'Want to become a',
                    Subtitle: 'Roommate?',
                    img: 'assets/images/logo.png',
                    color: AppColors.card2,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return RoommateCategoryPage();
                        },
                      ));
                    },
                  ),
                  ListingContainersWidget(
                    title: 'Want to list your',
                    Subtitle: 'Hostel / PG?',
                    img: 'assets/images/logo.png',
                    color: AppColors.card3,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return Hosteldetails();
                        },
                      ));
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListingContainersWidget(
                    title: 'Want to list your',
                    Subtitle: 'Bhojanalay?',
                    img: 'assets/images/logo.png',
                    color: AppColors.AppBar,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return Bhojnalaydetails();
                        },
                      ));
                    },
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  ListingContainersWidget(
                    title: 'Want to list your',
                    Subtitle: 'Office Space?',
                    img: 'assets/images/logo.png',
                    color: AppColors.card4,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return officeRoomForm();
                        },
                      ));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
