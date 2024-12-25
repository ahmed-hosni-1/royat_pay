library royat_pay;

import 'package:edfapg_sdk/edfapg_sdk.dart' as royat;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:royat_pay/models/error_response.dart';
import 'package:royat_pay/models/order_model.dart';
import 'package:royat_pay/models/pay_data.dart';
import 'package:royat_pay/models/payer_model.dart';
import 'package:royat_pay/models/redirect_response.dart';
import 'package:royat_pay/royat_iframe.dart';
import 'services/apis_servicese.dart';

/// Class representing the RoyatPay payment gateway.
class RoyatPay {
  /// Singleton instance of RoyatPay
  static final RoyatPay instance = RoyatPay._internal();

  /// Private constructor to enforce singleton pattern
  RoyatPay._internal();

  late String _key; // API key for the payment gateway
  late String _password; // API password for the payment gateway

  // Error response and redirect response variables
  ErrorResponse? _errorResponse;
  late RedirectResponse _redirectResponse;

  /// Initialize the RoyatPay instance with the given key and password.
  void init({required String key, required String password}) {
    _key = key;
    _password = password;
  }

  /// Handle error callback when there is an error during payment processing.
  void onError(ErrorResponse errorResponse) {}

  /// Get the last error response if any occurred during payment processing.
  ErrorResponse? getErrorResponse() => _errorResponse;

  /// Process payment using card details.
  Future<void> payWithCard({
    required BuildContext context, // Build context for displaying UI elements
    required PayData payData, // Payment data including amount, currency, etc.
    required Function onSuccess, // Callback to execute on successful payment
  }) async {
    payData.user = User(
        key: _key, password: _password); // Set user credentials for the payment

    final response = await ApisServices.instance
        .payWithCard(payData); // Call API to process payment

    if (kDebugMode) {
      _logResponse(response.data); // Log response data in debug mode
    }

    // Handle different response scenarios
    if (response.statusCode == 200) {
      _handleCardResponse(response.data, context, onSuccess);
    }
  }

  /// Handle response from card payment processing.
  void _handleCardResponse(
      dynamic data, BuildContext context, Function onSuccess) {
    if (data['result'] == 'ERROR') {
      _errorResponse = ErrorResponse.fromJson(data); // Parse error response
      onError(_errorResponse!); // Call error callback
    } else if (data['result'] == 'redirect') {
      _redirectResponse =
          RedirectResponse.fromJson(data); // Parse redirect response
      RoyatIFrame.show(
          context: context,
          redirectResponse: _redirectResponse,
          onSuccess: onSuccess); // Show iframe for redirection
    } else if (data['result'] == true) {
      onSuccess(); // Execute success callback
    }
  }

  /// Process payment using Apple Pay.
  void payWithApplePay({
    required BuildContext context, // Build context for displaying UI elements
    required String merchantId, // Merchant ID for Apple Pay
    required RoyatOrder order, // Order details including amount, description, etc.
    required RoyatPayer payer, // Environment for Apple Pay
    // required String currency,
    // required Customer customer, // Customer details for billing
    required Function(Map<dynamic, dynamic> error)
    onError, // Callback for error during payment
    required Function(Map<dynamic, dynamic> response)
    onTransactionFailure, // Callback for transaction failure
    required Function(Map<dynamic, dynamic> response)
    onTransactionSuccess, // Callback for successful transaction
    required Function(Map<dynamic, dynamic> response)
    onAuthentication, // Callback for authentication
  }) {
    try{


      // Initialize payment gateway

      royat.EdfaPgSaleOrder royatOrder = royat.EdfaPgSaleOrder(
        amount: order.amount,
        currency: order.currency,
        description: order.description,
        id: order.id,
      );


      royat.EdfaPgPayer royatPayer = royat.EdfaPgPayer(
        ip: payer.ip,
        city: payer.city,
        address: payer.address,
        zip: payer.zip,
        firstName: payer.firstName,
        lastName: payer.lastName,
        email: payer.email,
        phone: payer.phone,
        country: payer.country,
        options: royat.EdfaPgPayerOption(
          address2: payer.options?.address2,
          state: payer.options?.state,
          birthdate: payer.options?.birthdate,
          middleName: payer.options?.middleName
        )
      );


      // // Create sale order object
      // final saleOrder = royat.EdfaPgSaleOrder(
      //   amount: order.amount, // Amount to be charged
      //   currency: currency, // Currency code
      //   description: order.description, // Description of the order
      //   id: order.id, // Unique order ID
      // );

      // Create payer object with customer details
      // final payer = royat.EdfaPgPayer(
      //     ip: customer.ip ?? "66.249.64.248", // Customer's IP address
      //     city: customer.city, // Customer's city
      //     address: customer.address, // Customer's address
      //     zip: customer.zip??"123768", // Customer's ZIP code
      //     firstName: customer.name??"Ahmed Moahmed", // Customer's first name
      //     lastName: customer.lastName??"Ahmed Moahmed", // Customer's last name
      //     email: customer.email??"info@royat.sa", // Customer's email address
      //     phone: customer.phone, // Customer's phone number
      //     country: customer.country, // Customer's country
      //     options: royat.EdfaPgPayerOption(
      //       middleName: customer.name,
      //       birthdate: DateTime.parse("1987-03-30"),
      //       address2: "Usman Bin Affan",
      //       state: "Al Izdihar",
      //     ));


      // Initialize Apple Pay payment
      royat.EdfaApplePay()
          .setOrder(royatOrder) // Set the sale order
          .setPayer(royatPayer) // Set the payer details
          .setApplePayMerchantID(merchantId) // Set the Apple Pay Merchant ID
          .onAuthentication((response) {
        _logResponse("onAuthentication");

        _logResponse(response);
        onAuthentication(response);
      },) // Set authentication callback
          .onTransactionSuccess((response) {
        _logResponse("onTransactionSuccess");

        _logResponse(response);
        onTransactionSuccess(response);

        ;        },) // Set transaction success callback
          .onTransactionFailure((response) {
        _logResponse("onTransactionFailure");

        _logResponse(response);
        onTransactionFailure(response);

      },) // Set transaction failure callback
          .onError((response) {
        _logResponse("onError");

        _logResponse(response);

        onError(response);

      },) // Set error callback
          .initialize(context); // Initialize payment processing
    }catch(e){
      _logResponse("catch Error");

      _logResponse(e);

    }

  }

  /// Log response data for debugging purposes.
  void _logResponse(dynamic data) {
    debugPrint("========== RoyatPay ==========");
    debugPrint(data.toString());
    debugPrint("========== RoyatPay ==========");
  }

// // Callbacks for handling responses and errors
// Function(Map<dynamic, dynamic>) onAuthenticationCallback(
//     Function(Map<dynamic, dynamic>) callback) {
//   return (response) {
//     if (kDebugMode) _logResponse(response); // Log response in debug mode
//     callback(response); // Execute the original callback
//   };
// }
//
// Function(Map<dynamic, dynamic>) onTransactionSuccessCallback(
//     Function(Map<dynamic, dynamic>) callback) {
//   return (response) {
//     if (kDebugMode) _logResponse(response); // Log response in debug mode
//     callback(response); // Execute the original callback
//   };
// }
//
// Function(Map<dynamic, dynamic>) onTransactionFailureCallback(
//     Function(Map<dynamic, dynamic>) callback) {
//   return (response) {
//     if (kDebugMode) _logResponse(response); // Log response in debug mode
//     callback(response); // Execute the original callback
//   };
// }
//
// onErrorCallback(Map<dynamic, dynamic> callback) {
//   return (error) {
//     if (kDebugMode) _logResponse(error); // Log error response in debug mode
//   };
// }
}







// library royat_pay;

// import 'package:edfapg_sdk/edfapg_sdk.dart' as royat;
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:royat_pay/models/error_response.dart';
// import 'package:royat_pay/models/pay_data.dart';
// import 'package:royat_pay/models/redirect_response.dart';
// import 'package:royat_pay/royat_iframe.dart';
// import 'services/apis_servicese.dart';

// /// Class representing the RoyatPay payment gateway.
// class RoyatPay {
//   /// Singleton instance of RoyatPay
//   static final RoyatPay instance = RoyatPay._internal();

//   /// Private constructor to enforce singleton pattern
//   RoyatPay._internal();

//   late String _key; // API key for the payment gateway
//   late String _password; // API password for the payment gateway

//   // Error response and redirect response variables
//   ErrorResponse? _errorResponse;
//   late RedirectResponse _redirectResponse;

//   /// Initialize the RoyatPay instance with the given key and password.
//   void init({required String key, required String password}) {
//     _key = key;
//     _password = password;
//   }

//   /// Handle error callback when there is an error during payment processing.
//   void onError(ErrorResponse errorResponse) {}

//   /// Get the last error response if any occurred during payment processing.
//   ErrorResponse? getErrorResponse() => _errorResponse;

//   /// Process payment using card details.
//   Future<void> payWithCard({
//     required BuildContext context, // Build context for displaying UI elements
//     required PayData payData, // Payment data including amount, currency, etc.
//     required Function onSuccess, // Callback to execute on successful payment
//   }) async {
//     payData.user = User(
//         key: _key, password: _password); // Set user credentials for the payment

//     final response = await ApisServices.instance
//         .payWithCard(payData); // Call API to process payment

//     if (kDebugMode) {
//       _logResponse(response.data); // Log response data in debug mode
//     }

//     // Handle different response scenarios
//     if (response.statusCode == 200) {
//       _handleCardResponse(response.data, context, onSuccess);
//     }
//   }

//   /// Handle response from card payment processing.
//   void _handleCardResponse(
//       dynamic data, BuildContext context, Function onSuccess) {
//     if (data['result'] == 'ERROR') {
//       _errorResponse = ErrorResponse.fromJson(data); // Parse error response
//       onError(_errorResponse!); // Call error callback
//     } else if (data['result'] == 'redirect') {
//       _redirectResponse =
//           RedirectResponse.fromJson(data); // Parse redirect response
//       RoyatIFrame.show(
//           context: context,
//           redirectResponse: _redirectResponse,
//           onSuccess: onSuccess); // Show iframe for redirection
//     } else if (data['result'] == true) {
//       onSuccess(); // Execute success callback
//     }
//   }

//   /// Process payment using Apple Pay.
//   void payWithApplePay({
//     required BuildContext context, // Build context for displaying UI elements
//     required String merchantId, // Merchant ID for Apple Pay
//     required Order order, // Order details including amount, description, etc.
//     required Customer customer, // Customer details for billing
//     required Function(Map<dynamic, dynamic> error)
//         onError, // Callback for error during payment
//     required Function(Map<dynamic, dynamic> response)
//         onTransactionFailure, // Callback for transaction failure
//     required Function(Map<dynamic, dynamic> response)
//         onTransactionSuccess, // Callback for successful transaction
//     required Function(Map<dynamic, dynamic> response)
//         onAuthentication, // Callback for authentication
//   }) {
//     // Create sale order object
//     final saleOrder = royat.EdfaPgSaleOrder(
//       amount: order.amount, // Amount to be charged
//       currency: "SAR", // Currency code
//       description: order.description, // Description of the order
//       id: order.id, // Unique order ID
//     );

//     // Create payer object with customer details
//     final payer = royat.EdfaPgPayer(
//       ip: customer.ip, // Customer's IP address
//       city: customer.city, // Customer's city
//       address: customer.address, // Customer's address
//       zip: customer.zip, // Customer's ZIP code
//       firstName: customer.name, // Customer's first name
//       lastName: customer.lastName, // Customer's last name
//       email: customer.email, // Customer's email address
//       phone: customer.phone, // Customer's phone number
//       country: customer.country, // Customer's country
//     );

//     // Initialize Apple Pay payment
//     royat.EdfaApplePay()
//         .setOrder(saleOrder) // Set the sale order
//         .setPayer(payer) // Set the payer details
//         .setApplePayMerchantID(merchantId) // Set the Apple Pay Merchant ID
//         .onAuthentication(onAuthenticationCallback(
//             onAuthentication)) // Set authentication callback
//         .onTransactionSuccess(onTransactionSuccessCallback(
//             onTransactionSuccess)) // Set transaction success callback
//         .onTransactionFailure(onTransactionFailureCallback(
//             onTransactionFailure)) // Set transaction failure callback
//         .onError(onErrorCallback(onError)) // Set error callback
//         .initialize(context); // Initialize payment processing
//   }

//   /// Log response data for debugging purposes.
//   void _logResponse(dynamic data) {
//     debugPrint("========== RoyatPay ==========");
//     debugPrint(data.toString());
//     debugPrint("========== RoyatPay ==========");
//   }

//   // Callbacks for handling responses and errors
//   Function(Map<dynamic, dynamic>) onAuthenticationCallback(
//       Function(Map<dynamic, dynamic>) callback) {
//     return (response) {
//       if (kDebugMode) _logResponse(response); // Log response in debug mode
//       callback(response); // Execute the original callback
//     };
//   }

//   Function(Map<dynamic, dynamic>) onTransactionSuccessCallback(
//       Function(Map<dynamic, dynamic>) callback) {
//     return (response) {
//       if (kDebugMode) _logResponse(response); // Log response in debug mode
//       callback(response); // Execute the original callback
//     };
//   }

//   Function(Map<dynamic, dynamic>) onTransactionFailureCallback(
//       Function(Map<dynamic, dynamic>) callback) {
//     return (response) {
//       if (kDebugMode) _logResponse(response); // Log response in debug mode
//       callback(response); // Execute the original callback
//     };
//   }

//   Function(Map<dynamic, dynamic>) onErrorCallback(
//       Function(Map<dynamic, dynamic>) callback) {
//     return (error) {
//       if (kDebugMode) _logResponse(error); // Log error response in debug mode
//       callback(error); // Execute the original callback
//     };
//   }
// }