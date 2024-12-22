import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maan/Constants/AppConstants.dart';
import '../../ApiServices/ApiServices.dart';
import '../../Components/CustomButton2.dart';
import 'login.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _fullNameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.AppBar,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              // Container(
              //   color: Colors.white,
              //   child: Padding(
              //     padding: const EdgeInsets.only(top: 10.0,right: 5),
              //     child: Align(
              //       alignment: Alignment.bottomRight,
              //       child: IconButton(
              //           onPressed: () {
              //             Navigator.pop(context);
              //           },
              //           icon: Icon(
              //             CupertinoIcons.xmark,
              //             color: Colors.grey,
              //           )),
              //     ),
              //   ),
              // ),
              Container(
                height: 20,
                color: Colors.white,
              ),
              Stack(children: [
                Container(
                  color: Colors.white,
                  width: double.infinity,
                  child: Column(
                    children: [
                      SizedBox(
                        height: screenHeight * 0.12,
                        child: Image.asset(
                          'assets/images/logo.png',
                          height: screenHeight * 0.12,
                        ),
                      ),
                      Text(
                        'Search | Connect | Stay',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.035,
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
                Positioned(
                    top: 0,
                    right: 10,
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(CupertinoIcons.xmark)))
              ]),
              Container(
                width: double.infinity,
                color: AppColors.AppBar,
                padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.020,
                    horizontal: screenWidth * 0.04),
                child: Column(
                  children: [
                    Text(
                      'Register',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.06,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    _buildTextField(
                      controller: _fullNameController,
                      labelText: 'Full Name',
                      icon: Icons.person,
                      screenWidth: screenWidth,
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    _buildTextField(
                      controller: _emailController,
                      labelText: 'Email',
                      icon: Icons.email,
                      screenWidth: screenWidth,
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    _buildTextField(
                      controller: _phoneController,
                      labelText: 'Phone Number',
                      icon: Icons.phone,
                      screenWidth: screenWidth,
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    _buildTextField(
                      controller: _passwordController,
                      labelText: 'Password',
                      icon: Icons.lock,
                      screenWidth: screenWidth,
                      obscureText: true,
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                      child: Text(
                        'By tapping on create account you are accepting terms & conditions, legal terms and privacy & policy of saathraho.com',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.025,
                          color: Colors.black54,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    CustomRoundedButton(
                      label: 'Create an account',
                      onPressed: () async {
                        print('object');
                        print(_fullNameController.text.toString());
                        print(_emailController.text.toString());
                        print(_phoneController.text.toString());
                        print(_passwordController.text.toString());
                        await ApiFunctions().signup(
                            name: _fullNameController.text.toString(),
                            email: _emailController.text.toString(),
                            password: _passwordController.text.toString(),
                            phoneNo: _phoneController.text.toString(),
                            context: context);
                      },
                      width1: screenWidth * 0.6,
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      'or',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.04,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    CustomRoundedButton(
                      logo: true,
                      label: 'Sign in with google',
                      onPressed: () {},
                      width1: screenWidth * 0.6,
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style:
                              GoogleFonts.poppins(fontSize: screenWidth * 0.03),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                            );
                          },
                          child: Text(
                            "Login",
                            style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    required double screenWidth,
    bool obscureText = false,
  }) {
    return Container(
      width: screenWidth * 0.8,
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.035),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: labelText,
          hintStyle: GoogleFonts.poppins(color: Colors.grey),
          prefixIcon: Icon(
            icon,
            color: Colors.black,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            // borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
