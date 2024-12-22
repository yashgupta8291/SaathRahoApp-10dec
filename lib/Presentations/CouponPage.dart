import 'package:flutter/material.dart';
import 'package:maan/Components/CustomButton.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ApiServices/ApiServices.dart';
import '../ApiServices/transactionServices.dart';
import '../Components/CustomButton2.dart';
import 'Payment.dart';

class PaymentPreviewPage extends StatefulWidget {
  final int price;

  const PaymentPreviewPage({super.key, required this.price});

  @override
  State<PaymentPreviewPage> createState() => _PaymentPreviewPageState();
}

class _PaymentPreviewPageState extends State<PaymentPreviewPage> {
  late int finalprice;
  bool isCouponValid = false;
  bool isLoading = false;

  final TextEditingController codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    finalprice = widget.price; // Initialize final price
  }

  Future<void> checkCoupon(String code) async {
    setState(() {
      isLoading = true;
    });

    try {
      final value = await ApiFunctions.verifyCoupon(code);
      setState(() {
        isCouponValid = value as bool;
        if (isCouponValid) {
          finalprice = (widget.price * 0.8).toInt(); // Apply discount
        } else {
          finalprice = widget.price; // Reset to original price
        }
      });
    } catch (error) {
      debugPrint("Error verifying coupon: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to verify coupon. Please try again.")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Preview'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Total Amount: ₹$finalprice',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            TextField(
              controller: codeController,
              decoration: InputDecoration(
                labelText: 'Enter Coupon Code',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () => checkCoupon(codeController.text.trim()),
                    child: Text('Apply Coupon'),
                  ),
            Spacer(),
            CustomRoundedButton(
              onPressed: () async {
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                String? number = prefs.getString('phoneNo');
                String? email = prefs.getString('email');

                RazorpayService.openCheckout(
                  name: 'Standard Plan',
                  price: finalprice, // Amount in paise
                  description: 'Subscription plan',
                  context: context,
                  number: number ?? '',
                  email: email ?? '',
                  membership: 'Premium', // Pass membership type
                  onSuccessCallback: (membership, amount) async {
                    try {
                      final res = await Transaction().createTransaction(
                        token: RazorpayService.tokenController.token.value,
                        amount: amount,
                        membership: membership,
                      );

                      String email = prefs.getString('email') ?? '';
                      String pass = prefs.getString('password') ?? '';
                      await ApiFunctions().login(
                          email: email, password: pass, context: context);

                      debugPrint("Transaction Response: $res");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                "Payment Successful: ₹$amount for $membership")),
                      );
                    } catch (error) {
                      debugPrint("Transaction error: $error");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Transaction failed.")),
                      );
                    }
                  },
                );
              },
              label: 'Continue to Pay',
              width1: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}
