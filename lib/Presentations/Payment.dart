import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:maan/GetX/TokenController.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../ApiServices/transactionServices.dart';

class RazorpayService {
  static late Razorpay _razorpay;
  static TokenController tokenController = Get.find();
  static void initialize() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  static void dispose() {
    _razorpay.clear(); // Clear all listeners when done
  }

  static void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Use a callback to pass the membership and amount
    debugPrint("Payment Successful: ${response.paymentId}");
  }

  static void openCheckout({
    required String name,
    required String number,
    required String email,
    required int price,
    required String description,
    required BuildContext context,
    required String membership,
    required Function(String membership, double amount) onSuccessCallback,
  }) {
    var options = {
      'key': 'rzp_test_LQzqvbK2cWMGRg',
      'amount': price, // Pass price dynamically
      'name': name, // Pass name dynamically
      'description': description, // Pass description dynamically
      'prefill': {
        'contact': number,
        'email': email,
      },
      'external': {
        'wallets': [],
      },
    };

    try {
      _razorpay.open(options);

      // Setting up success callback
      _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
          (PaymentSuccessResponse response) {
        onSuccessCallback(
            membership, price / 100.0); // Convert price to INR from paise
      });
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  static Future<void> _handlePaymentError(
      PaymentFailureResponse response) async {
    // Handle payment failure
    debugPrint("Payment Failed: ${response.message}");
  }

  static void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet selection
    debugPrint("External Wallet: ${response.walletName}");
  }
}
