import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maan/Components/CustomButton2.dart';

class Myplans extends StatefulWidget {
  const Myplans({super.key});

  @override
  State<Myplans> createState() => _MyplansState();
}

class _MyplansState extends State<Myplans> {
  bool IsAvailable = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: !IsAvailable
            ? PreferredSize(
                preferredSize: Size(500, 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    PlanButton(text: "My plans"),
                    PlanButton(text: "Transactions"),
                    PlanButton(text: "Dates"),
                  ],
                ),
              )
            : null,
        centerTitle: true,
        title: !IsAvailable
            ? Text(
                "My Purchase",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600, fontSize: 20),
              )
            : null,
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
      ),
      body: IsAvailable
          ? Center(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset("assets/images/logo.png"),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      "You haven’t took any plan",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: 10),
                    ),
                  ),
                  Text(
                    "Let’s explore plans, by clicking below",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: 10.2),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomRoundedButton(
                        label: "Become A Member",
                        onPressed: () {},
                        width1: 350),
                  )
                ],
              ),
            )
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(),
                  SizedBox(height: 2.0),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Active",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400, color: Colors.black),
                    ),
                  ),
                  SizedBox(height: 5.0),
                  _PurchaseItem(
                    title: 'Active',
                    date: 'Date of Purchasing',
                    plan: 'Plan Name',
                    expiring: 'Expiring on:',
                    action: 'Refund Plan',
                    inr: 'INR:',
                  ),
                  SizedBox(height: 16.0),
                  _PurchaseItem(
                    title: 'Expired / Completed',
                    date: 'Date of Purchasing',
                    plan: 'Plan Name',
                    expiring: 'Expiring on:',
                    action: 'Refund Process',
                    inr: 'INR:',
                  ),
                  SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Expired / Completed:",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400, color: Colors.black),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  _PurchaseItem(
                    title: 'Refunded',
                    date: 'Date of Purchasing',
                    plan: 'Plan Name',
                    expiring: 'Expiring on:',
                    action: 'Refunded',
                    inr: 'INR:',
                  ),
                  SizedBox(height: 16.0),
                  _PurchaseItem(
                    title: 'Expired',
                    date: 'Date of Purchasing',
                    plan: 'Plan Name',
                    expiring: 'Expired at:',
                    action: 'Expired',
                    inr: 'INR:',
                  ),
                ],
              ),
            ),
    );
  }
}

class PlanButton extends StatelessWidget {
  final String text;

  const PlanButton({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.black, width: 0.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Center(
            child: Text(
              text,
              style: GoogleFonts.poppins(fontSize: 11),
            ),
          ),
          Icon(
            CupertinoIcons.arrow_right,
            size: 12,
          ),
        ],
      ),
    );
  }
}

class _PurchaseItem extends StatelessWidget {
  final String title;
  final String date;
  final String plan;
  final String expiring;
  final String action;
  final String inr;

  _PurchaseItem({
    required this.title,
    required this.date,
    required this.plan,
    required this.expiring,
    required this.action,
    required this.inr,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Date of purchaing",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400, fontSize: 15),
              ),
              Container(
                child: Center(
                  child: Text(
                    "Refund Plan",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontSize: 11.5),
                  ),
                ),
                height: 25,
                width: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xFFCD9898)),
              )
            ],
          ),
          Text("Plan Name",style: GoogleFonts.poppins(fontWeight: FontWeight.w600),),
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Expiry on"),
              SizedBox(width: 190,),
              Text("INR: "),

            ],
          ),
        ],
      ),
    );
  }
}
