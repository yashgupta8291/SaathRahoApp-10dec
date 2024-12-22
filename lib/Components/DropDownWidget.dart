import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Constants/AppConstants.dart';

class CustomBorderedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomBorderedButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = AppConstants.screenWidth(context);
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: width*0.035),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: width / 1.35, // Fixed width
          height: width * 0.138, // Fixed height
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 0.5, color: Colors.black),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Color(0x3F000000), // Shadow color
                blurRadius: 1,
                offset: Offset(1, 1),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: Text(
                    text,
                    style: GoogleFonts.poppins(fontSize: 16.0, color: Colors.black),
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
