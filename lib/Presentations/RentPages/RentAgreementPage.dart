import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Components/CusomTextfield.dart';
import '../../Components/CustomButton2.dart';
import '../../Constants/AppConstants.dart';

class AgreementTerms extends StatelessWidget {
  final TextEditingController rentController = TextEditingController();
  final TextEditingController depositController = TextEditingController();
  final TextEditingController lockInPeriodController = TextEditingController();
  final TextEditingController validityController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController createdByController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                      "Agreement Terms",
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: width * 0.05),
              CustomTextField(
                hintText: "Monthly Rent",
                controller: rentController,
                icon: Icons.monetization_on,
              ),
              CustomTextField(
                hintText: "Security Deposit",
                controller: depositController,
                icon: Icons.lock,
              ),
              CustomTextField(
                hintText: "Lock-in Period (Months)",
                controller: lockInPeriodController,
                icon: Icons.access_time,
              ),
              CustomTextField(
                hintText: "Agreement Validity (Months)",
                controller: validityController,
                icon: Icons.calendar_today,
              ),
              CustomTextField(
                hintText: "Agreement Start Date",
                controller: startDateController,
                icon: Icons.date_range,
              ),
              CustomTextField(
                hintText: "Created By",
                controller: createdByController,
                icon: Icons.person,
              ),
              CustomTextField(
                hintText: "Email",
                controller: emailController,
                icon: Icons.email,
              ),
              SizedBox(height: width * 0.1),
              CustomRoundedButton(
                label: "Save and Continue",
                onPressed: () {
                  // Handle save and continue action
                },
                width1: width * 0.6,
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
