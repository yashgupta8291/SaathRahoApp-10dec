import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Constants/AppConstants.dart';

class CustomRoundedButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final double width1;
  final bool? logo;

  const CustomRoundedButton({
    Key? key,
    required this.label,
    required this.onPressed,
    required this.width1,
    this.logo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = AppConstants.screenWidth(context);
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 50,
        width: width1,
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 40.0),
        decoration: BoxDecoration(
          color: AppColors.buttonColor, // Light purple background
          borderRadius: BorderRadius.circular(30.0), // Rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Light shadow color
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3), // Shadow position
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (logo == true)
              Icon(FontAwesomeIcons.google), // Show icon if logo is true
            if (logo == true)
              SizedBox(
                  width: width *
                      0.02), // Add some space between icon and text if logo is present
            Flexible(
              child: Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 13.5,
                  color: Colors.black, // Black text color
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
