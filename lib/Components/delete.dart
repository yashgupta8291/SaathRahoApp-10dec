import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
Future<void> showDeleteAccountDialog(BuildContext context) {
  bool isChecked = false;

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            contentPadding: EdgeInsets.all(14),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text("Are you sure want to", style: GoogleFonts.poppins(fontSize: 13)),
                        ),
                        SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(
                            "Delete Account?",
                            style: GoogleFonts.poppins(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.red[100], shape: BoxShape.circle),
                      child: Icon(Icons.delete_forever_rounded, color: Colors.red, size: 24),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    "All the data and purchases related to xyz@gmail.com will be permanently deleted.",
                    style: GoogleFonts.poppins(fontSize: 11, color: Colors.black87, fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 1.0, top: 10),
                        child: Text(
                          "I understand, that deleted account is not able to get recovered once it got deleted.",
                          style: GoogleFonts.poppins(fontSize: 10, color: Colors.black87),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: isChecked ? () {} : null,
                    child: Text('Delete', style: GoogleFonts.poppins(fontSize: 16, color: Colors.black)),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel', style: GoogleFonts.poppins(fontSize: 16, color: Colors.black)),
                  ),
                ],
              ),
            ],
          );
        },
      );
    },
  );
}