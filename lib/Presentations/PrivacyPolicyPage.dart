import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyPolicy extends StatefulWidget {
  @override
  _PrivacyPolicyState createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: IconButton(
          icon: Icon(CupertinoIcons.back, color: Colors.grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Privacy Policy",
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              """At Saath Raho, we are committed to protecting your privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you visit our website and use our app to connect with others for shared living arrangements, including finding roommates, rooms, hostels, PGs, and bhojanalays.""",
              style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey),
            ),
            SizedBox(height: 15),
            Text(
              "Information We Collect",
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
            ),
            SizedBox(height: 15),
            Text(
              """Personal Information: When you create an account, you may provide us with personal details such as your name, email address, phone number, and location.
Profile Information: Information you choose to share on your profile, including preferences, interests, and listing details.
Usage Data: Information about how you use our website and app, including your IP address, browser type, and pages visited.
Cookies and Tracking Technologies: We use cookies and similar technologies to collect information about your interactions with our services.""",
              style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey),
            ),
            SizedBox(height: 15),
            Text(
              "Information We Collect",
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
            ),
            SizedBox(height: 15),
            Text(
              """
To provide and maintain our services.
To personalize your experience and improve our platform.
To communicate with you about your account, listings, and our services.
To analyze usage and trends to enhance our offerings.
To detect, prevent, and address technical issues or fraudulent activity.""",
              style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey),
            ),
            SizedBox(height: 15),
            Text(
              "Information We Collect",
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
            ),
            SizedBox(height: 15),
            Text(
              """We do not sell or rent your personal information to third parties. We may share your information in the following circumstances:
With Service Providers: We may share your information with third-party vendors who assist us in providing our services, subject to confidentiality agreements.
For Legal Reasons: We may disclose your information if required by law or in response to valid requests by public authorities.
Business Transfers: In the event of a merger, acquisition, or asset sale, your information may be transferred as part of that transaction.""",
              style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey),
            ),
            SizedBox(height: 15),
            Text(
              "Your Rights",
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
            ),
            SizedBox(height: 15),
            Text(
              """Access, update, or delete your personal information at any time through your account settings.
Opt-out of receiving promotional communications by following the unsubscribe instructions provided in those emails.
Request that we restrict or cease the processing of your personal information.""",
              style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey),
            ),
            SizedBox(height: 15),
            Text(
              "Data Security",
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
            ),
            SizedBox(height: 15),
            Text(
              """We take the security of your information seriously and implement reasonable measures to protect it. However, no method of transmission over the internet or electronic storage is 100% secure. While we strive to protect your personal information, we cannot guarantee its absolute security.""",
              style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey),
            ),
            SizedBox(height: 15),
            Text(
              "Third Party Links",
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
            ),
            SizedBox(height: 15),
            Text(
              """Our website and app may contain links to third-party websites. We are not responsible for the privacy practices of these external sites. We encourage you to review their privacy policies before providing any personal information.""",
              style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey),
            ),
            SizedBox(height: 15),
            Text(
              "Changes to this privacy policy",
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
            ),
            SizedBox(height: 15),
            Text(
              """
We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new policy on this page and updating the “Last Updated” date at the top. We encourage you to review this Privacy Policy periodically for any changes.""",
              style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey),
            ),
            SizedBox(height: 15),
            Text(
              "Contact Us",
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
            ),
            SizedBox(height: 15),
            Text(
              """If you have any questions or concerns about this Privacy Policy or our practices, please contact us""",
              style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey),
            ),
            SizedBox(height: 15),
            Divider(),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(FontAwesomeIcons.instagram),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.facebook),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(FontAwesomeIcons.youtube),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(FontAwesomeIcons.linkedinIn),
                  onPressed: () {},
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  "@saathraho All rights reserved",
                  style: GoogleFonts.poppins(color: Colors.grey, fontSize: 8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
