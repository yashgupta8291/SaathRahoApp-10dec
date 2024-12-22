import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:maan/Presentations/AddListingPage.dart';
import 'package:maan/Presentations/Authentication/login.dart';
import 'package:maan/Presentations/ChatPages/ChatPage.dart';
import 'package:maan/Presentations/PlanPages/LIstingPlanPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ApiServices/GetApis.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double iconSize = screenWidth * 0.07;
    double textSize = screenWidth * 0.027;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 0.5, color: Colors.black87),
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                  0, Bootstrap.house, 'Home', iconSize, textSize, context),
              _buildNavItem(1, CupertinoIcons.chat_bubble_text, 'Chat',
                  iconSize, textSize, context),
              Padding(
                padding: const EdgeInsets.only(top: 3.0),
                child: _buildAddButton(iconSize, textSize, context),
              ),
              _buildNavItem(3, Iconsax.crown_outline, 'Prime', iconSize,
                  textSize, context),
              _buildNavItem(4, Icons.favorite_border, 'Wishlist', iconSize,
                  textSize, context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, double iconSize,
      double textSize, BuildContext context) {
    final isSelected = selectedIndex == index;
    return InkWell(
      onTap: () async {
        final prefs = await SharedPreferences.getInstance();
        bool isLogin = prefs.getBool('isLogin') ?? false;

        if (!isLogin) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        }
        if (isLogin) {
          if (index == 1) {
            // Only push to ChatPage if index is 1
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return ChatPage();
              },
            ));
          } else {
            // Do nothing for other indexes
            onItemSelected(index);
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: iconSize,
              color: isSelected ? Colors.black : Colors.grey,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: textSize,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton(
      double iconSize, double textSize, BuildContext context) {
    return InkWell(
      onTap: () async {
        final prefs = await SharedPreferences.getInstance();
        bool isLogin = prefs.getBool('isLogin') ?? false;
        if (!isLogin) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        }
        String membership = prefs.getString('membership') ?? '';
        int num = await ApiFunctionsGet().MyListingCount();
        print(num);
        print(membership);

        if (num != 0) {
          if (membership == 'Free') {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return ListingPlanPage();
              },
            ));
          } else {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return Addlistingpage();
              },
            ));
          }
        } else {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return Addlistingpage();
            },
          ));
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 7.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: iconSize * 1.5,
              height: iconSize * 1.5,
              child: Center(
                child: Icon(
                  CupertinoIcons.plus,
                  size: 35,
                  color: Colors.black54,
                ),
              ),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 0.7),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Add Listing",
              style: GoogleFonts.poppins(
                fontSize: textSize,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
