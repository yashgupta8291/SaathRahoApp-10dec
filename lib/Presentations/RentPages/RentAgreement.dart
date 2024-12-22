import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maan/Presentations/RentPages/RentAgreementPage.dart';
import '../../Components/DropDownWidget.dart';
import '../../Constants/AppConstants.dart';
import 'OwnerDeatils.dart';
import 'PropertyDeatils.dart';
import 'TenantPage.dart';
import 'itemPage.dart';

class RentListPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Screen size for responsiveness
    final size = MediaQuery.of(context).size;
    double width = AppConstants.screenWidth(context);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(CupertinoIcons.back),
            onPressed: () {
              Navigator.pop(context);
              // Handle back action
            },
          ),
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          'Rent Agreement',
                          style: GoogleFonts.poppins(
                            fontSize: size.width * 0.05,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: width * 0.2),
                      CustomBorderedButton(
                        text: 'Owner Details',
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return OwnerDetails();
                            },
                          ));
                        },
                      ),
                      CustomBorderedButton(
                        text: 'Tenant Details',
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return TenantPage();
                            },
                          ));
                        },
                      ),
                      CustomBorderedButton(
                        text: 'Property Details',
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return PropertyDetails();
                            },
                          ));
                        },
                      ),
                      CustomBorderedButton(
                        text: 'Agreement Terms',
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return AgreementTerms();
                            },
                          ));
                        },
                      ),
                      CustomBorderedButton(
                        text: 'Annexures',
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return RentAgreementForm();
                            },
                          ));
                        },
                      ),
                    ]))));
  }
}
