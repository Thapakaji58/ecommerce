import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:khalti_flutter/khalti_flutter.dart';

import '../main.dart';
import '../models/cart_item.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String referenceId = '';

  void onSuccess(PaymentSuccessModel success) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Payment Successful'),
            actions: [
              SimpleDialogOption(
                child: const Text('OK'),
                onPressed: () {
                  setState(() {
                    referenceId = success.idx;
                  });
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  void onFailure(PaymentFailureModel failure) {
    debugPrint(failure.toString());
  }

  void onCancel() {
    debugPrint('Cancelled');
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme
        .of(context)
        .textTheme;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Checkout',
          style: textTheme.headlineSmall,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(children: [
            Text(
              'Khalti Payment',
              style: textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            ElevatedButton(
                onPressed: () {
                  payWithKhaltiInApp(cart.totalPrice);
                },
                child: Text('Pay with Khalti')),
            Text('referenceID'),
            Text(referenceId),
          ]),
        ),
      ),
    );
  }

  void payWithKhaltiInApp(int totalPrice) {
    final List<CartItem> cartItems = cart.cartItems;
    // Check if the cart is not empty
    if (cartItems.isNotEmpty) {
      // Choose the first item in the cart as an example (modify as needed)
      final CartItem firstCartItem = cartItems.first;

      // Extract information for payment config
      final String productIdentity = firstCartItem.product.id;
      final String productName = firstCartItem.product.name;


      KhaltiScope.of(context).pay(
        config: PaymentConfig(
            amount: cart.totalPrice,
            productIdentity: productIdentity,
            productName: productName),
        preferences: [
          PaymentPreference.khalti,
        ],
        onSuccess: onSuccess,
        onFailure: onFailure,
        onCancel: onCancel,
      );
    }
  }
}
