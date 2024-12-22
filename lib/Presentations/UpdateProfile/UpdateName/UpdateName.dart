import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maan/ApiServices/ApiServices.dart';
import 'package:maan/GetX/TokenController.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Components/CusomTextfield.dart';
import '../../../Components/CustomButton2.dart';

class UpdateNamePage extends StatefulWidget {
  @override
  State<UpdateNamePage> createState() => _UpdateNamePageState();
}

class _UpdateNamePageState extends State<UpdateNamePage> {
  final TextEditingController nameController = TextEditingController();
final TokenController tokenController =Get.find();
  @override
  void initState() {
    super.initState();
  }

  Future<void> _updateName() async {
    final String newName = nameController.text.trim();
    if (newName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Name cannot be empty')),
      );
      return;
    }

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? email = prefs.getString('email');

      if (email != null) {
        await ApiFunctions().UpdateName(email, newName, context);
        await prefs.setString('name', newName); // Save new name locally
        tokenController.name.value = newName; // Save new name locally
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Name updated successfully')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No current name found.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating name: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 16),
            Text(
              'Update Name',
              style: GoogleFonts.poppins(
                  fontSize: 20, fontWeight: FontWeight.w500
              ),
            ),
            SizedBox(height: 3),
            Divider(thickness: 1, color: Colors.grey[300]),
            SizedBox(height: 40),
            CustomTextField(
              controller: nameController,
              hintText: "Enter New Name",
              icon: Icons.person,
            ),
            SizedBox(height: 54),
            CustomRoundedButton(
              label: "Update",
              onPressed: _updateName,
              width1: 200,
            ),
            SizedBox(height: 50),
            Image.asset("assets/images/logo.png"),
          ],
        ),
      ),
    );
  }
}
