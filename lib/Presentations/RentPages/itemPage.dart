import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maan/Components/CustomButton2.dart';

import '../../Constants/AppConstants.dart';

class RentAgreementForm extends StatefulWidget {
  const RentAgreementForm({Key? key}) : super(key: key);

  @override
  State<RentAgreementForm> createState() => _RentAgreementFormState();
}

class _RentAgreementFormState extends State<RentAgreementForm> {
  // List to store the item-quantity pairs
  final List<Map<String, TextEditingController>> _itemFields = [];

  @override
  void initState() {
    super.initState();
    // Add initial three fields
    _addNewField();
    _addNewField();
    _addNewField();
  }

  void _addNewField() {
    setState(() {
      _itemFields.add({
        'item': TextEditingController(),
        'quantity': TextEditingController(),
      });
    });
  }

  @override
  void dispose() {
    // Clean up controllers
    for (var field in _itemFields) {
      field['item']?.dispose();
      field['quantity']?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = AppConstants.screenWidth(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(

        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
              'Rent Agreement',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
             Text(
              'Items Provided',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
             Text(
              'Enter the furniture / item details provided to tenant.',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _itemFields.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Items"),
                              ),
                              TextFormField(
                                controller: _itemFields[index]['item'],
                                decoration: InputDecoration(
                                  hintText: 'Eg: Fans',
                                  hintStyle: GoogleFonts.poppins(color: Colors.grey),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide:
                                        const BorderSide(color: Colors.grey),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 30,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Quantity"),
                              ),
                              TextFormField(
                                controller: _itemFields[index]['quantity'],
                                decoration: InputDecoration(
                                  hintText: 'Eg: Fans',
                                  hintStyle: GoogleFonts.poppins(color: Colors.grey),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide:
                                        const BorderSide(color: Colors.grey),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 30,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            TextButton(
              onPressed: _addNewField,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.add, color: Colors.blue),
                  const SizedBox(width: 8),
                  Text(
                    'Add another items',
                    style: GoogleFonts.poppins(color: Colors.blue),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: CustomRoundedButton(
                  label: "Submit Agreement",
                  onPressed: () {},
                  width1: width * 0.6),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
