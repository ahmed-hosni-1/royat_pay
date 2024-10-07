import 'package:flutter/material.dart';
import 'package:royat_pay/models/pay_data.dart';
import 'package:royat_pay/royat_pay.dart';

class RoyatApplePayButton extends StatelessWidget {
  String merchantId;
  Order order;
  Customer customer;
   dynamic Function(Map<dynamic, dynamic>) onError;
       dynamic Function(Map<dynamic, dynamic>) onTransactionFailure;
       dynamic Function(Map<dynamic, dynamic>) onTransactionSuccess;
       dynamic Function(Map<dynamic, dynamic>) onAuthentication;

  RoyatApplePayButton({
    Key? key,
    required this.order,
    required this.merchantId,
    required this.customer,
    required this.onError,
    required this.onTransactionFailure,
    required this.onTransactionSuccess,
    required this.onAuthentication
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        RoyatPay.instance.payWithApplePay(
          context: context,
          merchantId: merchantId,
          order: order,
          customer: customer,
          onError: onError,
          onTransactionFailure: onTransactionFailure,
          onTransactionSuccess: onTransactionSuccess,
          onAuthentication: onAuthentication
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: const BoxDecoration(
          color: Color(0xff101010),
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              Icons.apple,
              color: Colors.white,
              size: 20,
            ),
            Text(
              'Pay',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'halter',
                fontSize: 14,
                package: 'flutter_credit_card',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
