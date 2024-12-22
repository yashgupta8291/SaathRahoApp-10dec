import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Components/CusomTextfield.dart';
import '../../Components/CustomButton2.dart';
import '../../Constants/AppConstants.dart';

class TenantPage extends StatelessWidget {
  TenantPage({Key? key}) : super(key: key);

  // Controllers for the text fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Screen size for responsiveness
    final size = MediaQuery.of(context).size;
    double width = AppConstants.screenWidth(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(CupertinoIcons.back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding:
            EdgeInsets.symmetric(horizontal: width * 0.1), // Adjusted padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Rent Agreement',
                style: GoogleFonts.poppins(
                  fontSize: size.width * 0.05,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: width * 0.1),
            Text(
              "Who is renting the property",
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            Text(
              "Fill in the details below as the tenant.",
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: 13,
              ),
            ),
            SizedBox(height: width * 0.1),
            CustomTextField(
              hintText: 'Full Name',
              icon: CupertinoIcons.person,
              controller: nameController,
            ),
            CustomTextField(
              hintText: 'Phone No.',
              icon: Icons.phone,
              controller: phoneController,
            ),
            CustomTextField(
              hintText: 'Complete Address',
              icon: CupertinoIcons.location,
              controller: addressController,
            ),
            SizedBox(height: width * 0.1),
            Center(
              child: CustomRoundedButton(
                label: "Save and Continue",
                onPressed: () {
                  // Handle the save action
                },
                width1: width * 0.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
