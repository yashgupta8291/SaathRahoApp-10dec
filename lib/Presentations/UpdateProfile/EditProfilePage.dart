import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maan/ApiServices/ApiServices.dart';
import 'package:maan/Components/CustomButton2.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ApiServices/ImageUploadService.dart';
import '../../GetX/TokenController.dart';
import 'UpdateAddress/Updateaddress.dart';
import 'UpdateEmail/ConfirmEmail.dart';
import 'UpdateName/UpdateName.dart';
import 'UpdatePassword/changePassword.dart';
import 'UpdatePhoneNumber/updatephone.dart';

class EditProfilePage extends StatefulWidget {
  EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  final TokenController tokenController = Get.find();

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  Future<void> _uploadImageToCloudinary() async {
    if (_selectedImage != null) {
      try {
        String? imageUrl = await uploadImageToCloudinary(_selectedImage!);
        if (imageUrl != null) {
          await ApiFunctions()
              .updateProfilePic(tokenController.email.value, imageUrl);
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('profilePic', imageUrl);
          tokenController.profilePic.value = imageUrl;
          print("Profile picture updated successfully.");
        } else {
          print("Failed to upload the image.");
        }
      } catch (e) {
        print("Error uploading image: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'Edit Profile',
            style: GoogleFonts.poppins(color: Colors.black),
          ),
        ),
        body: Obx(() => SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),

                  // Profile Image
                  Center(
                    child: Stack(
                      children: [
                        Obx(
                          () => CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey[200],
                              backgroundImage: _selectedImage != null
                                  ? FileImage(_selectedImage!)
                                  : NetworkImage(
                                      tokenController.profilePic.value)),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: InkWell(
                            onTap: _pickImage,
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
                              ),
                              child: Icon(Icons.edit,
                                  color: Colors.white, size: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32),

                  // Form Fields
                  _buildFormField(
                    'Full name',
                    tokenController.name.value!,
                    'Update Name',
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UpdateNamePage()),
                    ),
                  ),
                  _buildFormField(
                    'Email',
                    tokenController.email.value,
                    'Update Email',
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UpdateEmailPage()),
                    ),
                  ),
                  _buildFormField(
                    'Phone No.',
                    tokenController.phoneNumber.value!,
                    'Update Phone No.',
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Updatephone()),
                    ),
                  ),
                  _buildFormField(
                    'Password',
                    '************',
                    'Update Password',
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Changepassword()),
                    ),
                  ),

                  SizedBox(height: 32),

                  // Update Button
                  Center(
                    child: CustomRoundedButton(
                      label: "Upload Profile Picture",
                      onPressed: _uploadImageToCloudinary,
                      width1: 350,
                    ),
                  ),
                ],
              ),
            )));
  }
}

Widget _buildFormField(
    String label, String value, String updateText, VoidCallback onTap) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 15.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.black),
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                value,
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: onTap,
              child: Text(
                updateText,
                style: GoogleFonts.poppins(color: Colors.black54, fontSize: 11),
              ),
            ),
          ],
        ),
        Divider(),
        SizedBox(height: 15),
      ],
    ),
  );
}
