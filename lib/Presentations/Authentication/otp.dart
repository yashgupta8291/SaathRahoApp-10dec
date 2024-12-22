import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maan/ApiServices/ApiServices.dart';
import 'package:pinput/pinput.dart';
import 'dart:async';
import '../../Constants/AppConstants.dart';
import '../../Components/CustomButton2.dart';

class OtpPage extends StatefulWidget {
  final String email;
  final String phone;
  final String password;
  final String name;

  OtpPage(
      {required this.email,
      required this.phone,
      required this.password,
      required this.name}); // Use named parameters with required keyword

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final TextEditingController _otpController = TextEditingController();
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
      print('object');
      await ApiFunctions().verifyOTP(
          email: widget.email,
          otp: _otpController.text.toString(),
          context: context, password: widget.password);
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
      backgroundColor: AppColors.AppBar,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 18.0, right: 10),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(CupertinoIcons.xmark)),
                  ),
                ),
                height: 80,
                color: Colors.white,
              ),
              Container(
                color: Colors.white,
                width: double.infinity,
                child: Column(
                  children: [
                    SizedBox(
                      height: screenHeight * 0.14,
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: screenHeight * 0.10,
                      ),
                    ),
                    Text(
                      'Search | Connect | Stay',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    )
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                color: AppColors.AppBar,
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
                    SizedBox(height: screenHeight * 0.02),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                      child: Text(
                        'Check your notification email for your OTP',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.03,
                          color: Colors.black54,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
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
                    checkotp.isNotEmpty
                        ? SizedBox(
                            height: 20,
                          )
                        : SizedBox(),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                      child: Text(
                        'By tapping on create account you are accepting terms & conditions,legal terms and privacy & policy of saathraho.com',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.026,
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
                              ? () async {
                                  startTimer();
                                  await ApiFunctions().resendOtp(widget.email);
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
                    SizedBox(height: screenHeight * 0.01),
                    Center(
                      child: Image.asset(
                        "assets/images/logo.png",
                        width: 150,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
