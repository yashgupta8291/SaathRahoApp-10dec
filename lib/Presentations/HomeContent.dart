import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maan/Presentations/Authentication/login.dart';
import 'package:maan/Presentations/DetailsPage/RommateDetail.dart';
import 'package:maan/Presentations/Forms/Consuntation%20page.dart';
import 'package:maan/Presentations/PlanPages/LIstingPlanPage.dart';
import 'package:maan/Presentations/support.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ApiServices/GetApis.dart';
import '../Components/HomePageComponents.dart';
import '../Constants/AppConstants.dart';
import 'Forms/ListFlatRoomsForm.dart';
import 'Forms/bhojnalaydetails.dart';
import 'Forms/hosteldetails.dart';
import 'Forms/officespace.dart';
import 'Forms/roommate.dart';
import 'RentPages/RentAgreement.dart';

class Homecontent extends StatelessWidget {
  const Homecontent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          FreeListingSection(),
          SizedBox(
            height: 30.h,
          ),
          Text(
            "Categories",
            style: GoogleFonts.poppins(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 16.sp),
          ),
          SizedBox(
            height: 30.h,
          ),
          Center(
            child: Container(
              height: MediaQuery.of(context).size.width * 0.20,
              child: Category(
                count: 5,
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.13,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1),
              child: Text(
                "Take our services",
                style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.04,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TakeOurServices(
                color: AppColors.buttonColor,
                img: 'assets/svgs/TakeOurServices1.svg',
                name: 'Consultation',
                page: ConsultationForm(),
              ),
              TakeOurServices(
                color: AppColors.card2,
                img: 'assets/svgs/TakeOurServices2.svg',
                name: 'Rent Agreement',
                page: RentListPreview(),
              ),
              TakeOurServices(
                color: AppColors.card3,
                img: 'assets/svgs/TakeOurServices3.svg',
                name: 'Verified Listing',
                page: ListingPlanPage(
                  isAppbar: true,
                ),
              ),
              TakeOurServices(
                color: AppColors.AppBar,
                img: 'assets/svgs/TakeOurServices1.svg',
                name: 'Support 24/7',
                page: SupportChatScreen(),
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.13,
          ),
          Text(
            "We are in several cities ",
            style: GoogleFonts.poppins(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: MediaQuery.of(context).size.width * 0.04),
          ),
          Text(
            "Some of them are ",
            style: GoogleFonts.poppins(
                color: Colors.black,
                fontWeight: FontWeight.w300,
                fontSize: MediaQuery.of(context).size.width * 0.029),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.05,
          ),
          Center(
            child: Container(
              height: MediaQuery.of(context).size.width *
                  0.2, // Set height dynamically
              child: City(count: 12), // The City widget with the desired count
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.13,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.08),
              child: Row(
                children: [
                  Text(
                    "List your ",
                    style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: MediaQuery.of(context).size.width * 0.035),
                  ),
                  Text(
                    "Requirements",
                    style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: MediaQuery.of(context).size.width * 0.034),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.015,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.width * 0.03),
                      color: AppColors.card4,
                    ),
                    height: MediaQuery.of(context).size.width * 0.04,
                    width: MediaQuery.of(context).size.width * 0.08,
                    child: Center(
                      child: Text(
                        "Free",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize:
                                MediaQuery.of(context).size.width * 0.022),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.04,
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
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    bool isLogin = prefs.getBool('isLogin') ?? false;

                    String membership = prefs.getString('membership') ?? '';

                    if (!isLogin) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    }
                    int num = await ApiFunctionsGet().MyListingCount();
                    print(num);
                    print(membership);

                    if (membership == 'Free') {
                      if (num != 0) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ListingPlanPage()),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FlatRoomForm()),
                        );
                      }
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FlatRoomForm()),
                      );
                    }
                  },
                ),
                ListingContainersWidget(
                  title: 'Want to become a',
                  Subtitle: 'Roommate?',
                  img: 'assets/images/logo.png',
                  color: AppColors.card2,
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    String membership = prefs.getString('membership') ?? '';
                    int num = await ApiFunctionsGet().MyListingCount();
                    print(num);
                    print(membership);
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => RoomForm()),
                    // );
                    if (membership == 'Free') {
                      if (num != 0) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ListingPlanPage()),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RoomForm()),
                        );
                      }
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RoomForm()),
                      );
                    }
                  },
                ),
                ListingContainersWidget(
                  title: 'Want to list your',
                  Subtitle: 'Hostel / PG?',
                  img: 'assets/images/logo.png',
                  color: AppColors.card3,
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    String membership = prefs.getString('membership') ?? '';
                    int num = await ApiFunctionsGet().MyListingCount();
                    print(num);
                    print(membership);

                    if (membership == 'Free') {
                      if (num != 0) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ListingPlanPage()),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Hosteldetails()),
                        );
                      }
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Hosteldetails()),
                      );
                    }
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
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    String membership = prefs.getString('membership') ?? '';
                    int num = await ApiFunctionsGet().MyListingCount();
                    print(num);
                    print(membership);

                    if (membership == 'Free') {
                      if (num != 0) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ListingPlanPage()),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Bhojnalaydetails()),
                        );
                      }
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Bhojnalaydetails()),
                      );
                    }
                  },
                ),
                SizedBox(width: 30),
                ListingContainersWidget(
                  title: 'Want to list your',
                  Subtitle: 'Office Space?',
                  img: 'assets/images/logo.png',
                  color: AppColors.card4,
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    String membership = prefs.getString('membership') ?? '';
                    int num = await ApiFunctionsGet().MyListingCount();
                    print(num);
                    print(membership);
                    if (membership == 'Free') {
                      if (num != 0) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ListingPlanPage()),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => officeRoomForm()),
                        );
                      }
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => officeRoomForm()),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25),
            child: Row(
              children: [
                Expanded(
                  child: Divider(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0), // Adjust horizontal padding as needed
                  child: Icon(Icons.arrow_drop_down),
                ),
                Expanded(
                  child: Divider(),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MemberWidget(),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: SubsbcribeWidget(),
                )
              ],
            ),
          ),
          SizedBox(
            height: 40,
          ),
        ],
      ),
    );
    ;
  }
}
