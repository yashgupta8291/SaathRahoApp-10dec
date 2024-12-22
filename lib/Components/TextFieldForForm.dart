import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';

import '../GetX/pincodeController.dart';

Widget buildTextFieldswithHints(
  String label,
  String hint,
  TextEditingController controller,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 13,
          color: Colors.black,
        ),
      ),
      SizedBox(
        height: 3,
      ),
      Container(
        width: double.infinity,
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 0.4, color: Colors.black), // Black border
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Center(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.poppins(color: Colors.grey),
              isDense: true, // Reduces the height of the TextField
              border: InputBorder.none, // Removes the default TextField border
            ),
          ),
        ),
      ),
    ],
  );
}

Widget buildDropdownField(String title, List<String> options, String? value,
    Function(String?) onChanged) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      const SizedBox(height: 8),
      DropdownButton<String>(
        value: value,
        isExpanded: true,
        hint: Text("Select $title"),
        icon: const Icon(Icons.keyboard_arrow_down, size: 30),
        underline: const Divider(),
        items: options.map((String option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(option),
          );
        }).toList(),
        onChanged: onChanged,
      ),
      const SizedBox(height: 16),
    ],
  );
}

Widget buildTextFieldsWithPincode(
  String label,
  String hint,
  TextEditingController controller,
  PincodeController pincodeController,
) {
  final PincodeController pincodeController = Get.find();
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 13,
          color: Colors.black,
        ),
      ),
      SizedBox(height: 3),
      Container(
        width: double.infinity,
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 0.4, color: Colors.black),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: GoogleFonts.poppins(color: Colors.grey),
                  isDense: true,
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(width: 8),
            Obx(
              () => ElevatedButton(
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    print('object');
                    pincodeController.verifyPincode(controller.text);
                  } else {
                    Get.snackbar(
                      "Error",
                      "Pincode cannot be empty!",
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  textStyle: GoogleFonts.poppins(fontSize: 12),
                ),
                child: pincodeController.isPincodeVerified.value
                    ? Text("Verified")
                    : Text("Verify"),
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 12),
      Obx(
        () => Container(
          height: 45,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 0.4, color: Colors.black),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              pincodeController.pincode.value,
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: Colors.blue,
              ),
            ),
          ),
        ),
      ),
      SizedBox(height: 12),
    ],
  );
}
