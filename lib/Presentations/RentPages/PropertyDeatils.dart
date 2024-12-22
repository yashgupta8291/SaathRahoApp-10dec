import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Components/CusomTextfield.dart';
import '../../Components/CustomButton2.dart';
import '../../Constants/AppConstants.dart';

class PropertyDetails extends StatelessWidget {
  final TextEditingController stateController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
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
          icon: Icon(CupertinoIcons.back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
              SizedBox(height: width * 0.2),
              Align(
                alignment: AlignmentDirectional.topStart,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Property Ownership",
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "Fill in the details below as the owner or renter.",
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: width * 0.05),
              CustomTextField(
                hintText: 'State',
                icon: CupertinoIcons.map,
                controller: stateController,
              ),
              CustomTextField(
                hintText: 'City',
                icon: Icons.location_city,
                controller: cityController,
              ),
              CustomTextField(
                hintText: 'Pincode',
                icon: CupertinoIcons.number,
                controller: pincodeController,
              ),
              CustomTextField(
                hintText: 'House and Street Address',
                icon: CupertinoIcons.location,
                controller: addressController,
              ),
              SizedBox(height: width * 0.1),
              CustomRoundedButton(
                label: "Save and Continue",
                onPressed: () {
                  // Handle save and continue action here
                },
                width1: width * 0.6,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
