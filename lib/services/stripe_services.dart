import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:payment_gateway_flutter/constants/constants.dart';

class StripeServices {
  StripeServices._();

  static final StripeServices instance = StripeServices._();

  Future<void> makePayment(BuildContext context) async {
    try {
      String? paymentIntentClientSecret =
          await _createPaymentIntent(100, "usd");
      if (paymentIntentClientSecret == null) return;
      // initializing payment sheet
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntentClientSecret,
        merchantDisplayName: "azix khan",
      ));
      await _processPayment(context);
    } catch (e) {
      print(e);
    }
  }

  Future<String?> _createPaymentIntent(int amount, String currency) async {
    try {
      final Dio dio = Dio();
      Map<String, dynamic> data = {
        "amount": _calculateAmount(amount),
        "currency": currency,
      };
      var response = await dio.post(
        "https://api.stripe.com/v1/payment_intents",
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            "Authorization": "Bearer $stripeSecretKey",
            "Content-Type": 'application/x-www-form-urlencoded',
          },
        ),
      );
      if (response.data != null) {
        return response.data["client_secret"];
      }
      return null;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<void> _processPayment(BuildContext context) async {
    try {
      await Stripe.instance.presentPaymentSheet();
      await Stripe.instance.confirmPaymentSheetPayment();
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Payment failed: ${e.toString()}")),
      );
    }
  }

  String _calculateAmount(int amount) {
    final calculateAmount = amount * 100;
    return calculateAmount.toString();
  }
}
