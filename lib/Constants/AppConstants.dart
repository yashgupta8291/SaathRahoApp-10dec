import 'package:flutter/cupertino.dart';

class AppConstants {
  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height; // Use height for screen height
  }

  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width; // Added for completeness
  }
}

class AppColors{
  static Color buttonColor = Color.fromRGBO(228, 193, 249, 1);
  static Color AppBar = Color.fromRGBO(208, 244, 222, 1);
  static Color card2 = Color.fromRGBO(169, 222, 249, 1);
  static Color card3 = Color.fromRGBO(252, 246, 189, 1);
  static Color card4 = Color.fromRGBO(255, 153, 200, 1);
}