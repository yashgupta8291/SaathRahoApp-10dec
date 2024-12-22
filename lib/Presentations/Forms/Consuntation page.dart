import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maan/ApiServices/ApiServices.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../../Components/CusomTextfield.dart';

import '../../Components/CustomButton2.dart';
import '../../Constants/AppConstants.dart';

class ConsultationForm extends StatefulWidget {
  @override
  _ConsultationFormState createState() => _ConsultationFormState();
}

class _ConsultationFormState extends State<ConsultationForm> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController availabilityController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> submitForm() async {
    if (_formKey.currentState!.validate()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String uid = prefs.getString('uid')!;
      await ApiFunctions().createConsultation(
        name: fullNameController.text,
        email: emailController.text,
        phoneNo: phoneNumberController.text,
        uid: uid,
      );
    }
  }

  Future<void> _pickDateTime() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      final DateTime combinedDateTime = DateTime(
        pickedDate!.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      setState(() {
        availabilityController.text =
            "${combinedDateTime.toLocal()}".split(' ')[0] +
                " ${pickedTime.format(context)}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double width = AppConstants.screenWidth(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(CupertinoIcons.back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Consultation',
                  style: GoogleFonts.poppins(
                    fontSize: size.width * 0.05,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width / 10),
                  child: Divider(thickness: 1),
                ),
                SizedBox(height: 16),

                // Custom Text Fields with validation
                CustomTextField(
                  controller: fullNameController,
                  hintText: 'Full Name',
                  icon: Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  controller: emailController,
                  hintText: 'Email',
                  icon: Icons.email,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                        .hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  controller: phoneNumberController,
                  hintText: 'Phone Number',
                  icon: Icons.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                ),
                GestureDetector(
                  onTap: _pickDateTime,
                  child: AbsorbPointer(
                    child: CustomTextField(
                      controller: availabilityController,
                      hintText: 'Time & Date Availability',
                      icon: Icons.date_range,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your availability';
                        }
                        return null;
                      },
                    ),
                  ),
                ),

                SizedBox(height: 10),
                CustomRoundedButton(
                  label: "Submit",
                  onPressed: submitForm,
                  width1: width * 0.55,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    availabilityController.dispose();
    super.dispose();
  }
}
