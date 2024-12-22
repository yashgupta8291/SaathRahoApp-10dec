import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maan/Constants/AppConstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ApiServices/ApiServices.dart';
import '../../ApiServices/transactionServices.dart';
import '../../Components/MemberShipContainers.dart';
import '../CouponPage.dart';
import '../Payment.dart';

class ListingPlanPage extends StatefulWidget {
  final bool isAppbar;
  const ListingPlanPage({super.key, this.isAppbar = false});
  @override
  State<ListingPlanPage> createState() => _ListingPlanPageState();
}

class _ListingPlanPageState extends State<ListingPlanPage> {
  @override
  void dispose() {
    RazorpayService.dispose(); // Clear Razorpay listeners
    super.dispose();
  }

  // Default value to false
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
                onTap: () async {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return PaymentPreviewPage(price:49999);
                  },));
                },
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: SvgPicture.asset(
                        "assets/svgs/plan1.svg",
                        height: 400,
                      ),
                    ),
                    Positioned(
                      bottom:
                          80, // The distance between the bottom of the screen and the container
                      left: 50,
                      right: 0,
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: MediaQuery.of(context).size.width *
                              0.6, // Adjust width if needed
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border.all(),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                spreadRadius: 0.5,
                                blurStyle: BlurStyle.inner,
                                offset: const Offset(5, 6),
                              )
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Center(
                            child: Text(
                              "Buy Now at 499/- only",
                              style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
            GestureDetector(
                onTap: () async {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return PaymentPreviewPage(price:7999);
                  },));
                },
                child: Stack(children: [
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: SvgPicture.asset("assets/svgs/plan2.svg"),
                  ),
                  Positioned(
                    bottom:
                        20, // The distance between the bottom of the screen and the container
                    left: 80,
                    right: 0,
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: MediaQuery.of(context).size.width *
                            0.6, // Adjust width if needed
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 0.5,
                              blurStyle: BlurStyle.inner,
                              offset: const Offset(5, 6),
                            )
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Center(
                          child: Text(
                            "Buy Now at 799/- only",
                            style: GoogleFonts.poppins(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ])),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
