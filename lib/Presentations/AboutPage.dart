import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maan/ApiServices/ApiServices.dart';
import 'package:maan/Components/CustomButton.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AboutUsPage extends StatefulWidget {
  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  bool isFeedbackVisible = false;
  TextEditingController _desController = TextEditingController();

  Future<void> _submitFeedback() async {
    // Get SharedPreferences instance
    print('object');
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the uid from SharedPreferences
    String? uid = prefs
        .getString('uid'); // Make sure 'uid' is the key you used when saving
    print(uid);

    // Call the submitFeedback API function
    await ApiFunctions().submitFeedback(uid!, _desController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(CupertinoIcons.back, color: Colors.grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "About Us",
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
              """
              At Saath Raho, we believe that finding the right living arrangement should be effortless and enjoyable. Our mission is to connect individuals seeking shared accommodations—whether it's finding roommates, renting rooms, booking hostels, securing PGs, or discovering bhojanalays—creating a vibrant community where everyone feels at home. 
    
              Founded with emerged from the idea that navigating housing options shouldn't be a hassle. We, recognized the challenges people face in finding safe, affordable, and compatible living situations. With a shared passion for innovation and community building, we set out to develop a user-friendly platform that simplifies the process of finding and sharing living spaces.
    
              Diverse Listings: Explore a wide range of options, including shared flats, private rooms, hostels, PG accommodations, and local bhojanalays—all in one place.
              Smart Matching: Our advanced algorithms help connect you with potential roommates and living arrangements that suit your preferences and lifestyle.
              Community Support: Join a thriving community where you can share experiences, seek advice, and connect with others who are on a similar journey.
              Safety First: We prioritize your safety by providing resources and guidelines to help you make informed decisions about your living arrangements.
    
              We envision a world where finding a place to live is not just about shelter, but about building connections and creating memories.
    
              Our platform is designed to foster relationships and enhance your living experience, making it easier to find your ideal home away from home.
              Whether you're a student looking for a roommate, a traveler seeking a hostel, or anyone in between, Saath Raho is here to help you navigate your housing journey.
              """,
              style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey),
            ),
            SizedBox(height: 15),
            Divider(),
            GestureDetector(
              onTap: () {
                setState(() {
                  isFeedbackVisible = !isFeedbackVisible;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Provide a Feedback",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                    Icon(
                      isFeedbackVisible
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 24,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
            if (!isFeedbackVisible) Divider(),
            if (isFeedbackVisible)
              Column(
                children: [
                  Container(
                    height: 80,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.only(left: 10),
                    child: TextField(
                      controller: _desController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Description',
                        hintStyle: GoogleFonts.poppins(
                            color: Colors.grey, fontSize: 12),
                      ),
                      maxLines: 5,
                    ),
                  ),
                  SizedBox(height: 16),
                  Custombutton(
                    text: "Submit",
                    onpressed: () {
                      _submitFeedback();
                    },
                  ),
                ],
              ),
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
