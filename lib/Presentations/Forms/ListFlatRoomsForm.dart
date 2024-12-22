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

class FlatRoomForm extends StatefulWidget {
  const FlatRoomForm({super.key});

  @override
  State<FlatRoomForm> createState() => _FlatRoomFormState();
}

class _FlatRoomFormState extends State<FlatRoomForm> {
  // Dropdown variables
  String? bathrooms;
  String? bedrooms;
  String? furnishing;
  String? bachelorsAllowed;
  String? listedBy;
  String? parking;
  String? category;
  final PincodeController pincodeController = Get.find();
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _advanceController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _monthlyMaintenanceController =
      TextEditingController();
  final TextEditingController _floorNoController = TextEditingController();
  final TextEditingController _totalFloorsController = TextEditingController();
  final TextEditingController _builtUpCarpetController =
      TextEditingController();
  final TextEditingController _facingController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _pincodeController =
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
      bool isFeatureListing = prefs.getBool('isFeatureListing') ?? false;
      await ApiFunctions().createRoomForm(
        parking: parking ?? '',
        facing: _facingController.text,
        bedrooms: bedrooms ?? '',
        bathroom: bathrooms ?? '',
        furnished: furnishing ?? '',
        bachelors: bachelorsAllowed.toString(),
        listedBy: listedBy ?? '',
        carpetArea: _builtUpCarpetController.text,
        totalFloor: _totalFloorsController.text,
        floorNo: _floorNoController.text,
        location: _locationController.text,
        monthlyMaintenance: _monthlyMaintenanceController.text,
        description: _descriptionController.text,
        images: images,
        amenities: selectedAmenities,
        isApproved: false,
        roomName: _ownerNameController.text,
        title: _titleController.text,
        uid: uid,
        categoryOfPeople: category.toString(),
        featureListing: isFeatureListing,
        advance: _advanceController.text,
        pincode: _pincodeController.text.toString(),
      );

      return true;
    } catch (e) {
      print('Error submitting form: $e');
      return false;
    }
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
                buildTextFieldswithHints("Advance amount if any",
                    "eg. 1000,2000...", _advanceController),
                buildTextFieldsWithPincode('Pincode', 'pincode/zipcode',
                    _pincodeController, pincodeController),
                buildDropdownField(
                    "No. of Bedrooms",
                    ["1 BHK", "2 BHK", "3 BHK", "4+ BHK"],
                    bedrooms,
                    (value) => setState(() => bedrooms = value)),
                buildDropdownField("No. of Bathrooms", ["1", "2", "3", "4+"],
                    bathrooms, (value) => setState(() => bathrooms = value)),
                buildDropdownField(
                    "Furnishing",
                    ["Fully Furnished", "Semi Furnished", "Unfurnished"],
                    furnishing,
                    (value) => setState(() => furnishing = value)),
                buildDropdownField(
                    "Bachelors Allowed",
                    ["Yes", "No"],
                    bachelorsAllowed,
                    (value) => setState(() => bachelorsAllowed = value)),
                buildDropdownField("Listed By", ["Owner", "Rental"], listedBy,
                    (value) => setState(() => listedBy = value)),
                buildDropdownField(
                    "Parking",
                    ["4 Wheeler", "2 Wheeler", "All Vehicle", "None"],
                    parking,
                    (value) => setState(() => parking = value)),
                buildDropdownField(
                    "Category of People",
                    ["Family", "Boys only", "Girls only", "Anyone"],
                    category,
                    (value) => setState(() => category = value)),
                const SizedBox(height: 16),
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
                        pincodeController.isPincodeVerified.value &&
                        _selectedImages.isNotEmpty) {
                      try {
                        // Show loading indicator
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );

                        // Upload images and submit the form
                        List<String> images = await uploadImagesToCloudinary();
                        bool success = await _submitForm(images);

                        // Close the loading indicator
                        Navigator.of(context, rootNavigator: true).pop();

                        if (success) {
                          pincodeController.isPincodeVerified.value = false;
                          pincodeController.pincode.value = '';
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Form submitted successfully')),
                          );
                          Navigator.pop(context);
                        } else {
                          pincodeController.isPincodeVerified.value = false;
                          pincodeController.pincode.value = '';
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Form submission failed. Please try again.')),
                          );
                        }
                      } catch (e) {
                        pincodeController.isPincodeVerified.value = false;
                        pincodeController.pincode.value = '';
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Error submitting form')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Please fill all fields and add images')),
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
}
