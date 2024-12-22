import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maan/Presentations/AboutPage.dart';
import 'package:maan/Presentations/MyListingPage.dart';
import 'package:maan/Presentations/Notifications.dart';
import 'package:maan/Presentations/PlanPages/LIstingPlanPage.dart';
import 'package:maan/Presentations/PrivacyPolicyPage.dart';
import 'package:maan/Presentations/UpdateProfile/EditProfilePage.dart';
import 'package:maan/Presentations/support.dart';
import 'package:maan/Presentations/transaction.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Components/LogoutVideo.dart';
import '../../Components/delete.dart';
import '../../GetX/TokenController.dart';

class ProfileScreen extends StatelessWidget {
  final TokenController tokenController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: IconButton(
          icon: Icon(CupertinoIcons.back, color: Colors.grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Profile",
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Padding(
              padding: const EdgeInsets.all(9.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                        () => Text(
                          tokenController.name.value,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      SizedBox(height: 4),
                      Obx(() => Text(tokenController.email.value)),
                      SizedBox(height: 4),
                      Obx(() => Text(tokenController.phoneNumber.value)),
                    ],
                  ),
                  Obx(() => CircleAvatar(
                        backgroundImage:
                            NetworkImage(tokenController.profilePic.value),
                        radius: 40,
                        backgroundColor: Colors.grey.shade300,
                      )),
                ],
              ),
            ),
            // Tab Buttons
            Padding(
              padding: const EdgeInsets.all(9.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(228, 193, 249, 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                height: 100,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ProfileOption(
                        icon: CupertinoIcons.profile_circled,
                        label: "Profile edit",
                        onTap: () {
                          print("object");
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return EditProfilePage();
                            },
                          ));
                        },
                      ),
                      ProfileOption(
                        icon: Icons.support_agent_outlined,
                        label: "Support",
                        onTap: () {
                          // Navigate to Support screen
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return SupportChatScreen();
                            },
                          ));
                        },
                      ),
                      ProfileOption(
                        icon: FontAwesomeIcons.envelope,
                        label: "Transaction",
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return TransactionsPage();
                            },
                          ));
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Personal Information
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Personal Information:',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.percent, size: 20, color: Colors.grey),
                    title: Text(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      'Coupon Activated  ${tokenController.couponCode.value}',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w400),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return ListingPlanPage(
                            isAppbar: true,
                          );
                        },
                      ));
                    },
                    leading: Icon(Icons.remember_me_sharp,
                        size: 20, color: Colors.grey),
                    title: Text(
                      'Purchase a membership plan',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w400),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return MyListingPage();
                        },
                      ));
                    },
                    leading: Icon(Icons.percent, size: 20, color: Colors.grey),
                    title: Text(
                      'My Listing',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            ),

            // Other Information
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Other Information:',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                  ListTile(
                    onTap: () async {
                      final String appLink =
                          "https://yourapp.com"; // Replace with your app link or URL
                      await Share.share('Check out this awesome app: $appLink');
                    },
                    leading: Icon(CupertinoIcons.share, color: Colors.grey),
                    title: Text(
                      'Share the App',
                      style: GoogleFonts.poppins(fontSize: 15),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return AboutUsPage();
                        },
                      ));
                    },
                    leading: Icon(CupertinoIcons.info, color: Colors.grey),
                    title: Text(
                      'About us',
                      style: GoogleFonts.poppins(fontSize: 15),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return PrivacyPolicy();
                        },
                      ));
                    },
                    leading: Icon(Icons.lock, color: Colors.grey),
                    title: Text(
                      'Privacy Policy',
                      style: GoogleFonts.poppins(fontSize: 15),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.delete_forever, color: Colors.grey),
                    onTap: () {
                      showDeleteAccountDialog(context);
                    },
                    title: Text(
                      'Delete / Remove Account',
                      style: GoogleFonts.poppins(fontSize: 15),
                    ),
                  ),
                  ListTile(
                    leading:
                        Icon(Icons.request_quote_outlined, color: Colors.grey),
                    title: Text(
                      'Request Refund',
                      style: GoogleFonts.poppins(fontSize: 15),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return NotificationsPage();
                        },
                      ));
                    },
                    leading: Icon(CupertinoIcons.bell_fill, color: Colors.grey),
                    title: Text(
                      'Notifications',
                      style: GoogleFonts.poppins(fontSize: 15),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      showLogoutAccountDialog(context);
                    },
                    leading: Icon(Icons.logout, color: Colors.grey),
                    title: Text(
                      'Log out',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Footer
            Center(
              child: Text(
                '@copyright All rights reserved',
                style: GoogleFonts.poppins(color: Colors.grey, fontSize: 10),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class ProfileOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const ProfileOption({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 28),
          SizedBox(height: 5),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
