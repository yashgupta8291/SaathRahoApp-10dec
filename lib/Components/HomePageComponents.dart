import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maan/Presentations/AddListingPage.dart';
import 'package:maan/Presentations/Authentication/login.dart';
import 'package:maan/Presentations/CategoryPages/CityCategoryPage.dart';
import 'package:maan/Presentations/CategoryPages/PropertyCategoryPage.dart';
import 'package:maan/Presentations/Forms/Consuntation%20page.dart';
import 'package:maan/Presentations/PlanPages/LIstingPlanPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ApiServices/NotificationServices.dart';
import '../Constants/AppConstants.dart';
import '../Presentations/CategoryPages/BhojanalayCategory.dart';
import '../Presentations/CategoryPages/Hostel.dart';
import '../Presentations/CategoryPages/RoomateCategoryPage.dart';
import '../Presentations/CategoryPages/office.dart';

// Free Listing Section Widget with CarouselSlider
class FreeListingSection extends StatelessWidget {
  List<String> Svgs = [
    'assets/svgs/1.svg',
    'assets/svgs/2.svg',
    'assets/svgs/3.svg',
  ];
  List<Widget> pages = [
    Addlistingpage(),
    BhojanalyaCategoryPage(),
    ConsultationForm(),
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: []),
      child: CarouselSlider(
        options: CarouselOptions(
            viewportFraction: 1,
            enlargeCenterPage: true,
            height: 120,
            autoPlay: true),
        items: [0, 1, 2].map((i) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.8), // Shadow color
                      blurRadius: 0.5, // Spread radius
                      offset: Offset(0, 0), // Position of the shadow
                    ),
                  ],
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(10), // Optional: Rounded corners
                ),
                child: GestureDetector(
                    onTap: () async {
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      bool isLogin = prefs.getBool('isLogin') ?? false;

                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return isLogin ? pages[i] : LoginPage();
                        },
                      ));
                    },
                    child: SvgPicture.asset(
                      Svgs[i],
                      fit: BoxFit.contain,
                    )),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}

class Category extends StatelessWidget {
  final int count;

  // Define constants to avoid recreating values
  static const double _avatarSize = 58.0;
  static const double _spacing = 5.0;
  static const double _fontSize = 8.0;
  static const Color _shadowColor = Colors.black26;
  static const Color _backgroundColor = Color.fromRGBO(252, 246, 189, 1);

  static const List<String> images = [
    "assets/svgs/category2.svg",
    "assets/svgs/category2.svg",
    "assets/svgs/category2.svg",
    "assets/svgs/category2.svg",
    "assets/svgs/category4.svg",
  ];

  static const List<String> categoryNames = [
    "Flat/Room",
    "Hostel/PG",
    "A Flatmate",
    "Office Space",
    "Bhojanalay"
  ];

  const Category({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double responsiveAvatarSize =
        screenWidth < 360 ? _avatarSize * 0.8 : _avatarSize;
    final double horizontalPadding = screenWidth * 0.05;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: count,
        physics: const BouncingScrollPhysics(),
        itemExtent: responsiveAvatarSize + 12,
        shrinkWrap: true, // To avoid full-screen scroll
        itemBuilder: (context, index) => _buildCategoryItem(
          index,
          images[index],
          categoryNames[index],
          context,
          responsiveAvatarSize,
        ),
      ),
    );
  }

  Widget _buildCategoryItem(
    int index,
    String imagePath,
    String categoryName,
    BuildContext context,
    double avatarSize,
  ) {
    return GestureDetector(
      onTap: () => _handleNavigation(context, index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: avatarSize,
            width: avatarSize,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: _backgroundColor,
              boxShadow: [
                BoxShadow(
                  color: _shadowColor,
                  offset: Offset(2.0, 2.0),
                  blurRadius: 4.0,
                ),
              ],
            ),
            child: SvgPicture.asset(
              imagePath,
              height: avatarSize * 0.10,
              width: avatarSize * 0.10,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: _spacing),
          Text(
            categoryName,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: _fontSize,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _handleNavigation(BuildContext context, int index) {
    final Widget page = _getPageForIndex(index);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  Widget _getPageForIndex(int index) {
    switch (index) {
      case 0:
        return PropertyCategoryPage();
      case 1:
        return HostelCategoryPage();
      case 2:
        return RoommateCategoryPage();
      case 3:
        return OfficeCategoryPage();
      case 4:
        return BhojanalyaCategoryPage();
      default:
        return BhojanalyaCategoryPage();
    }
  }
}

class City extends StatelessWidget {
  final int count;

  // Define constants to avoid recreating values
  static const double _avatarSize = 59.0;
  static const double _spacing = 5.0;
  static const double _fontSize = 8.5;
  static const Color _shadowColor = Colors.black26;
  static const Color _backgroundColor = Color.fromRGBO(252, 246, 189, 1);

  const City({super.key, required this.count});

  static List<String> CityNames = [
    "Katni",
    "Bangalore",
    "Jaipur",
    "Indore",
    "Mumbai",
    "Bangalore",
    "Jaipur",
    "Indore",
    "Mumbai",
    "Bangalore",
    "Jaipur",
    "Indore",
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      // Ensures the entire widget is centered horizontally
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 16.0), // Adjust horizontal padding if needed
        child: ListView.builder(
          // Changed to ListView for better performance
          scrollDirection: Axis.horizontal,
          itemCount: count,
          itemExtent: _avatarSize +
              30, // Fixed width for each item for better performance
          shrinkWrap: true, // Prevent ListView from expanding unnecessarily
          itemBuilder: (context, index) => GestureDetector(
            child: _buildCategoryItem(CityNames[index], context),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryItem(String city, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return CityCategoryPage(City: city);
          },
        ));
      },
      child: Column(
        mainAxisSize: MainAxisSize.min, // Optimize column size
        children: [
          Container(
            height: _avatarSize,
            width: _avatarSize,
            decoration: const BoxDecoration(
              shape: BoxShape.circle, // More efficient than ClipOval
              color: _backgroundColor,
              boxShadow: [
                BoxShadow(
                  color: _shadowColor,
                  offset: Offset(2.0, 2.0),
                  blurRadius: 4.0,
                ),
              ],
            ),
          ),
          const SizedBox(height: _spacing),
          Text(
            city,
            style: GoogleFonts.poppins(
              fontSize: _fontSize,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class TakeOurServices extends StatelessWidget {
  final Color color;
  final String img;
  final String name;
  final Widget page; // Add page parameter to receive the target page

  const TakeOurServices({
    super.key,
    required this.color,
    required this.img,
    required this.name,
    required this.page, // Initialize the target page in the constructor
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        bool isLogin = prefs.getBool('isLogin') ?? false;

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  isLogin ? page : LoginPage()), // Navigate to the target page
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              child: SvgPicture.asset(
                img,
                height: 80,
                width: 80,
              ),
              height: 100,
              width: 70, // Set a fixed width for the container
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: color,
              ),
            ),
            SizedBox(height: 5),
            Text(
              name,
              style: GoogleFonts.poppins(
                fontSize: 7.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ListingContainersWidget extends StatelessWidget {
  final String title;
  final String Subtitle;
  final String img;
  final Color color;
  final VoidCallback onTap;

  const ListingContainersWidget(
      {super.key,
      required this.title,
      required this.Subtitle,
      required this.img,
      required this.color,
      required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 9,
                ),
              ),
              Text(
                Subtitle,
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
              ),
              Spacer(),
              Align(
                  alignment: Alignment.bottomRight,
                  child: Image.asset(
                    img,
                    height: 50,
                    width: 50,
                  ))
            ],
          ),
        ),
        width: 110,
        height: 140,
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}

class MemberWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.centerRight,
          children: [
            Positioned(
              top: -47,
              right: 10,
              child: Opacity(
                opacity: 1,
                child: Image.asset(
                  'assets/images/member.png',
                  width: 70,
                  height: 70,
                ),
              ),
            ),
            Container(
              width: 160,
              height: 55,
              decoration: ShapeDecoration(
                color: Color(0xFFFF99C8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                shadows: [
                  BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 1,
                    offset: Offset(1, 2),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Become a Member of',
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                      ),
                      TextSpan(
                        text: ' \nRoomieQ india',
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: MediaQuery.of(context).size.width * 0.026,
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// TopBar Widge
class SubsbcribeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 0.5),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Text(
                    'Subscribe with EMAIL for Upcoming \nOffers/Discounts',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.black.withOpacity(0.6),
                      fontSize: 6.4,
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: CircleAvatar(
              child: Center(
                child: Icon(
                  CupertinoIcons.arrowtriangle_right_fill,
                  size: 16,
                ),
              ),
              // radius: 60,
              backgroundColor: AppColors.card2,
            ),
          )
        ],
      ),
    );
  }
}
