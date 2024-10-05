library royat_pay;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:royat_pay/models/error_response.dart';
import 'package:royat_pay/models/pay_data.dart';
import 'package:royat_pay/models/redirect_response.dart';
import 'package:royat_pay/royat_iframe.dart';

import 'services/apis_servicese.dart';

class RoyatPay {
  /// singleton
  RoyatPay._();

  /// to get the instance of royatPay
  static RoyatPay instance = RoyatPay._();
  late String _key;
  late String _password;

  /// to init the royatPay
  init({required String key, required String password}) {
    _key = key;
    _password = password;
  }

  ErrorResponse? _errorResponse;
  late RedirectResponse _redirectResponse;

  /// on error call
  onError(ErrorResponse errorResponse) {}

  /// to get the error response
  ErrorResponse? getErrorResponse() {
    return _errorResponse;
  }

  /// to make a payment with card
  payWithCard(
      {required BuildContext context,
      required PayData payData,
      required Function onSuccess}) async {
    payData.user = User(key: _key, password: _password);
    var response = await ApisServices.instance.payWithCard(payData);
    if (kDebugMode) {
      debugPrint("========== RoyatPay ==========");
      debugPrint(response.data);
      debugPrint("========== RoyatPay ==========");
    }
    if (response.statusCode == 200 && response.data['result'] == 'ERROR') {
      _errorResponse = ErrorResponse.fromJson(response.data);

      onError(_errorResponse!);
    } else if (response.statusCode == 200 &&
        response.data['result'] == 'redirect') {
      _redirectResponse = RedirectResponse.fromJson(response.data);
      RoyatIFrame.show(
          context: context,
          redirectResponse: _redirectResponse,
          onSuccess: onSuccess);
    } else if (response.statusCode == 200 && response.data['result'] == true) {
      onSuccess();
    }
  }
}
