import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:maan/Components/CustomButton2.dart';
import 'package:maan/Presentations/Authentication/signup_page.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../ApiServices/ApiServices.dart';
import '../../GetX/TokenController.dart';
import '../HomePage.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  final TokenController tokenController = Get.find();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;

    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        // backgroundColor: Colors.red,
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  CupertinoIcons.xmark,
                  color: Colors.grey,
                )),
          )
        ],
        backgroundColor: Color.fromRGBO(208, 244, 222, 1),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: Color.fromRGBO(208, 244, 222, 1),
              padding: EdgeInsets.symmetric(
                vertical: screenHeight * 0.0,
              ),
              child: Column(
                children: [
                  Container(
                    height: screenHeight * 0.15,
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: screenHeight * 0.1,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    'Search | Connect | Stay',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.045),
                  Text(
                    'Login',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.07,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: screenWidth * 0.18),
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        filled: true,
                        hintText: "Email",
                        hintStyle: GoogleFonts.poppins(color: Colors.grey),
                        fillColor: Colors.white,
                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          // borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: screenWidth * 0.18),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintStyle: GoogleFonts.poppins(color: Colors.grey),
                        hintText: "Password",
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          // borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                ],
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'Forgot Password?',
                style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.045, color: Colors.black),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            CustomRoundedButton(
              label: 'Login',
              onPressed: () async {
                print('object');
                await ApiFunctions().login(
                    email: _emailController.text.toString(),
                    password: _passwordController.text.toString(),
                    context: context);
              },
              width1: screenWidth * 0.6,
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(
              'or',
              style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.045, color: Colors.black54),
            ),
            SizedBox(height: screenHeight * 0.01),
            // CustomRoundedButton(
            //   label: 'Create an account',
            //   onPressed: () {
            //     Navigator.push(context, MaterialPageRoute(
            //       builder: (context) {
            //         return SignUpPage();
            //       },
            //     ));
            //   },
            //   width1: screenWidth * 0.6,
            // )
            SizedBox(height: screenHeight * 0.01),
            CustomRoundedButton(
              logo: true,
              label: 'Sign in with google',
              onPressed: () async {
                await ApiFunctions().signInWithGoogle(context);
              },
              width1: screenWidth * 0.6,
            ),
            SizedBox(height: screenHeight * 0.01),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                "Don't have an account? ",
                style: GoogleFonts.poppins(fontSize: screenWidth * 0.03),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpPage()),
                  );
                },
                child: Text(
                  "Sign up",
                  style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ]),
            SizedBox(
              height: 5,
            )
          ],
        ),
      ),
    );
  }
}