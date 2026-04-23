

import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../constants/api_constants.dart';

class RazorpayService {
  late Razorpay _razorpay;

  Function(PaymentSuccessResponse)? onSuccess;
  Function(PaymentFailureResponse)? onError;
  Function(ExternalWalletResponse)? onExternalWallet;

  RazorpayService() {
    _razorpay = Razorpay();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (response) {
      if (onSuccess != null) onSuccess!(response);
    });

    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (response) {
      if (onError != null) onError!(response);
    });

    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, (response) {
      if (onExternalWallet != null) onExternalWallet!(response);
    });
  }
  void openCheckoutWithOrderId({
    required int amount,
    required String orderId,
    required String key,
    required String name,
    required String description,
    required String contact,
    required String email,
  }) {
    var options = {
      // 'key':ApiConstants.razorPayKey,
      // 'key': 'rzp_test_hCRLFPf6rY3elm',
      'key': key,
      'amount': amount, // already in paise
      'name': name,
      'description': description,
      'order_id': orderId, // 🔥 MOST IMPORTANT
      'prefill': {
        'contact': contact,
        'email': email,
      },
      'theme': {'color': '#03045E'}
    };

    _razorpay.open(options);
  }
  // void openCheckoutWithOrderId({
  //   required String amount,
  //   required String name,
  //   required String description,
  //   required String contact,
  //   required String email,
  // }) {
  //   var options = {
  //     'key': 'rzp_test_hCRLFPf6rY3elm',
  //     'amount': (double.parse(amount) * 100).toInt(), // paisa me
  //     'name': name,
  //     'description': description,
  //     'prefill': {
  //       'contact': contact,
  //       'email': email,
  //     },
  //     'theme': {'color': '#050660'}
  //   };
  //
  //   _razorpay.open(options);
  // }

  void dispose() {
    _razorpay.clear();
  }
}