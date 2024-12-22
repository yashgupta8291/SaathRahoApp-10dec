import 'package:flutter/material.dart';
import 'package:get/get.dart'; // For GetX state management
import 'package:http/http.dart' as http;
import 'package:maan/ApiServices/ApiServices.dart';
import 'dart:convert';

import '../GetX/TokenController.dart';

class TransactionsPage extends StatefulWidget {
  @override
  _TransactionsPageState createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  final transactions = <Map<String, dynamic>>[].obs;
  final membershipDetails = {}.obs;
  final TokenController tokenController = Get.find();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    const apiUrl =
        '${ApiFunctions.baseUrl}/transaction'; // Replace with your API endpoint
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer ${tokenController.token.value}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['transactions'] != null) {
          transactions.value =
              List<Map<String, dynamic>>.from(data['transactions']);
        }
        membershipDetails.value = {
          "membership": data['membership'],
          "membershipStart": data['membershipStart'],
          "membershipExpiry": data['membershipExpiry'],
          "verified": data['verified'],
          "isFeatureListing": data['isFeatureListing'],
        };
      } else {
        Get.snackbar(
            'Error', 'Failed to fetch user data: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    }
  }

  Future<void> handleRefund(String transactionId) async {
    const refundApiUrl =
        'YOUR_REFUND_API_URL'; // Replace with your refund API endpoint
    try {
      final response = await http.post(
        Uri.parse(refundApiUrl),
        headers: {
          'Authorization': 'Bearer ${tokenController.token.value}',
          'Content-Type': 'application/json',
        },
        body: json.encode({'transactionId': transactionId}),
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Refund initiated successfully');
        fetchUserData(); // Refresh data
      } else {
        Get.snackbar(
            'Error', 'Failed to initiate refund: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions & Membership'),
      ),
      body: Obx(() {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Membership Details
              if (!transactions.isEmpty)
                Card(
                  margin: EdgeInsets.all(8.0),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Membership Details',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                            'Membership: ${membershipDetails['membership'] ?? 'N/A'}'),
                        Text(
                            'Start Date: ${membershipDetails['membershipStart'] != null ? DateTime.parse(membershipDetails['membershipStart']).toLocal() : 'N/A'}'),
                        Text(
                            'Expiry: ${membershipDetails['membershipExpiry'] == false ? 'Lifetime' : membershipDetails['membershipExpiry']}'),
                        Text(
                            'Verified: ${membershipDetails['verified'] ?? 'N/A'}'),
                        Text(
                            'Feature Listing: ${membershipDetails['isFeatureListing'] == true ? 'Yes' : 'No'}'),
                      ],
                    ),
                  ),
                ),

              // Transactions List
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Transactions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              if (transactions.isEmpty)
                Center(child: Text('No transactions available.')),
              if (transactions.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = transactions[index];
                    return Card(
                      child: ListTile(
                        title: Text('Transaction ID: ${transaction['_id']}'),
                        subtitle: Text(
                          'Amount: ₹${transaction['amount']}\nDate: ${DateTime.parse(transaction['transactionDate']).toLocal()}',
                        ),
                        trailing: ElevatedButton(
                          onPressed: () => handleRefund(transaction['_id']),
                          child: Text('Refund'),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      }),
    );
  }
}
