import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maan/ApiServices/ApiServices.dart';
import 'package:maan/Components/CusomTextfield.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Components/CustomButton2.dart';

class UpdatePassword extends StatefulWidget {
  @override
  _UpdateEmailPageState createState() => _UpdateEmailPageState();
}

class _UpdateEmailPageState extends State<UpdatePassword> {
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController newPass = TextEditingController();
  String checkotp = "";
  int timer = 60; // Starting timer at 60 seconds
  Timer? _timer;
  bool canResendOtp = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  void startTimer() {
    setState(() {
      timer = 60;
      canResendOtp = false;
    });

    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (this.timer > 0) {
          this.timer--;
        } else {
          canResendOtp = true;
          timer.cancel();
        }
      });
    });
  }

  Future<void> validateOtp() async {
    if (_otpController.text.isEmpty || _otpController.text.length != 5) {
      setState(() {
        checkotp = "Invalid OTP";
      });
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String email = prefs.getString('email')!;
      await ApiFunctions().verifyPasswordUpdate(context, email,
          _otpController.text.toString(), newPass.text.toString());
      // Add your OTP verification logic here
      prefs.setString('password', newPass.text.toString());
      setState(() {
        checkotp = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            Text(
              'Update Password',
              style: GoogleFonts.poppins(
                  fontSize: 20, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 4),
            Divider(thickness: 1, color: Colors.grey[300]),
            CustomTextField(
              controller: newPass,
              hintText: "Password",
              icon: Icons.password,
            ),
            SizedBox(
              height: 7,
            ),
            Container(
              width: double.infinity,
              color: Colors.transparent,
              padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.026,
                  horizontal: screenWidth * 0.04),
              child: Column(
                children: [
                  Text(
                    'OTP Verification',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Pinput(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      defaultPinTheme: PinTheme(
                        height: screenWidth * 0.135,
                        width: screenWidth * 0.130,
                        textStyle: GoogleFonts.poppins(color: Colors.black),
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          // border: Border.all(width: 1, color: Colors.black),
                        ),
                      ),
                      length: 5,
                      keyboardType: TextInputType.number,
                      controller: _otpController,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                    child: checkotp.isNotEmpty
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                CupertinoIcons.exclamationmark_triangle,
                                color: Colors.red,
                              ),
                              SizedBox(width: 8),
                              Text(
                                checkotp,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: screenWidth * 0.04,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          )
                        : null,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                    child: Text(
                      'By tapping on create account you are accepting terms & conditions,',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.025,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomRoundedButton(
                      label: "Submit OTP",
                      onPressed: validateOtp,
                      width1: screenWidth * 0.5,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    "${(timer ~/ 60).toString().padLeft(2, '0')}:${(timer % 60).toString().padLeft(2, '0')}",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Didn't get OTP? ",
                        style:
                            GoogleFonts.poppins(fontSize: screenWidth * 0.03),
                      ),
                      GestureDetector(
                        onTap: canResendOtp
                            ? () {
                                startTimer();
                                // Add your resend OTP logic here
                              }
                            : null,
                        child: Text(
                          "Resend OTP",
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.bold,
                            color: canResendOtp ? Colors.black : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Center(
                    child: Image.asset("assets/images/logo.png"),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
