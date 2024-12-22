import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
final double paddingSize = 8.0;
final TextStyle titleStyle = GoogleFonts.poppins(
  fontSize: 15,
  color: Colors.black,
  fontWeight: FontWeight.w500,
);

final TextStyle detailStyle = GoogleFonts.poppins(
  fontSize: 12,
  color: Colors.black,
  fontWeight: FontWeight.w300,
);

Widget detailRow(String title, String value) {
  return Padding(
    padding: EdgeInsets.all(paddingSize),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: titleStyle),
            Text(value, style: detailStyle),
          ],
        ),
        const Divider(),
      ],
    ),
  );
}
