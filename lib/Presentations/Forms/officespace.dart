import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../ApiServices/ApiServices.dart';
import '../../ApiServices/ImageUploadService.dart';
import '../../Components/AmenitiesComponent.dart';
import '../../Components/CustomButton2.dart';
import '../../Components/TextFieldForForm.dart';
import '../../Constants/AppConstants.dart';
import '../../GetX/pincodeController.dart';

class officeRoomForm extends StatefulWidget {
  const officeRoomForm({super.key});

  @override
  State<officeRoomForm> createState() => _officeRoomFormState();
}

class _officeRoomFormState extends State<officeRoomForm> {
  // Dropdown variables
  String? bathrooms;
  String? cabin;
  String? furnishing;
  String? listedBy;
  String? parking;
  final PincodeController pincodeController = Get.find();
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _monthlyMaintenanceController =
      TextEditingController();
  final TextEditingController _floorNoController = TextEditingController();
  final TextEditingController _totalFloorsController = TextEditingController();
  final TextEditingController _builtUpCarpetController =
      TextEditingController();
  final TextEditingController _facingController = TextEditingController();
  final TextEditingController _depositController = TextEditingController();
  final TextEditingController _pincodeController =
      TextEditingController(); // Pincode controller
  final TextEditingController _descriptionController =
  TextEditingController(); // Pincode controller

  List<String> selectedAmenities = [];
  List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  final _formKey = GlobalKey<FormState>();

  Future<void> _pickImage() async {
    try {
      final List<XFile>? pickedFiles = await _picker.pickMultiImage();
      if (pickedFiles != null) {
        setState(() {
          _selectedImages = pickedFiles.map((file) => File(file.path)).toList();
        });
      }
    } catch (e) {
      print("Error picking images: $e");
    }
  }

  Future<List<String>> uploadImagesToCloudinary() async {
    List<String> imageUrls = [];
    for (File image in _selectedImages) {
      try {
        String? imageUrl = await uploadImageToCloudinary(image);
        if (imageUrl != null) imageUrls.add(imageUrl);
      } catch (e) {
        print("Error uploading image: $e");
      }
    }
    return imageUrls;
  }

  Future<bool> _submitForm(List<String> images) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String uid = prefs.getString('uid') ?? '';
      bool feature = prefs.getBool('isFeatureListing') ?? false;

      await ApiFunctions().createOfficeListing(
        title: _ownerNameController.text,
        officeLocation: _locationController.text,
        officeTitle: _titleController.text,
        officeMonthlyMaintenance: _monthlyMaintenanceController.text,
        officeFloorNo: _floorNoController.text,
        officeTotalFloor: _totalFloorsController.text,
        carpetArea: _builtUpCarpetController.text,
        officeFacing: _facingController.text,
        officeDeposit: _depositController.text,
        parkingAvailable: parking ?? '',
        noOfBathrooms: bathrooms ?? '',
        noOfCabins: cabin ?? '',
        furnished: furnishing ?? '',
        listedBy: listedBy ?? '',
        officeDescription: _descriptionController.text.toString(),
        officeId: uid,
        isApproved: false,
        officeImages: images,
        feature: feature,
        pincode: _pincodeController.text.toString(),
      );

      return true;
    } catch (e) {
      print('Error submitting form: $e');
      return false;
    }
  }

  Widget buildDropdownField(String title, List<String> options, String? value,
      Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.AppBar,
        centerTitle: true,
        title: Text(
          "Add your Flat/Room Details",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 15),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTextFieldswithHints(
                    "Your Name", "Full Name", _ownerNameController),
                buildTextFieldswithHints(
                    "Location", "Add location", _locationController),
                buildTextFieldswithHints(
                    "Add Title", "Title of the property", _titleController),
                buildTextFieldswithHints("Monthly Maintenance",
                    "e.g. 500, 1000", _monthlyMaintenanceController),
                buildTextFieldswithHints("Floor No.",
                    "e.g. 1st Floor, 2nd Floor", _floorNoController),
                buildTextFieldswithHints("Total Floors",
                    "e.g. 2 Floors, 3 Floors", _totalFloorsController),
                buildTextFieldswithHints("Build-up Carpet", "e.g. 600 sq ft",
                    _builtUpCarpetController),
                buildTextFieldswithHints(
                    "Facing", "North, South, East", _facingController),
                buildTextFieldswithHints(
                    "Deposit", "e.g. 1month...", _depositController),

                buildTextFieldsWithPincode('Pincode', 'pincode/zipcode',
                    _pincodeController, pincodeController),

                buildDropdownField(
                    "No. of Cabins",
                    ["1", "2", "3", "4+"],
                    cabin,
                    (value) => setState(() => cabin = value)),
                buildDropdownField(
                    "No. of Bathrooms",
                    [
                      "1",
                      "2",
                      "3",
                    ],
                    bathrooms,
                    (value) => setState(() => bathrooms = value)),
                buildDropdownField(
                    "Furnishing",
                    ["Fully Furnished", "Semi Furnished", "Unfurnished"],
                    furnishing,
                    (value) => setState(() => furnishing = value)),

                buildDropdownField("Listed By", ["Owner", "Rental"], listedBy,
                    (value) => setState(() => listedBy = value)),
                buildDropdownField(
                    "Parking",
                    ["4 Wheeler", "2 Wheeler", "All Vehicle", "None"],
                    parking,
                    (value) => setState(() => parking = value)),

                const SizedBox(height: 16), // Added SizedBox for space
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Center(
                      child: Text(
                        _selectedImages.isEmpty
                            ? "Click or Drag to upload image"
                            : "${_selectedImages.length} image(s) selected",
                        style: GoogleFonts.poppins(fontSize: 11),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  width: double.infinity,
                  child: TextField(
                    controller: _descriptionController,
                    maxLines: null, // Allows the TextField to expand vertically
                    minLines: 3, // Sets a minimum height for better UX
                    keyboardType: TextInputType.multiline,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(
                          2500), // Approx. 500 words (average word = 5 chars)
                    ],
                    decoration: InputDecoration(
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      hintText: "Enter your description (up to 500 words)...",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                AmenitiesScreen(
                    onSelectedAmenitiesChanged: (items) =>
                        selectedAmenities = items),
                const SizedBox(height: 20),
                CustomRoundedButton(
                  label: "Submit Form",
                  onPressed: () async {
                    if (_formKey.currentState!.validate() &&
                        _selectedImages.isNotEmpty && pincodeController.isPincodeVerified.value) {
                      List<String> images = await uploadImagesToCloudinary();
                      bool success = await _submitForm(images);
                      if (success) {
                        pincodeController.isPincodeVerified.value = false;
                        pincodeController.pincode.value = '';
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Error submitting form")),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                "Please fill all fields and select images")),
                      );
                    }
                  },
                  width1: 450,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Function to create TextField with hints
  Widget buildTextFieldswithHints(
      String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(hintText: hint),
          validator: (value) =>
              value!.isEmpty ? 'This field cannot be empty' : null,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
