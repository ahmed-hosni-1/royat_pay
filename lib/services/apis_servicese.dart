import 'package:dio/dio.dart';
import 'package:royat_pay/models/pay_data.dart';
import 'package:network_info_plus/network_info_plus.dart';

class ApisServices {
  ApisServices._();
  static final ApisServices instance = ApisServices._();
  final info = NetworkInfo();

  final Dio _dio = Dio(BaseOptions(
    baseUrl: "https://api.royat.sa",
  ));

  Future<Response> payWithCard(PayData payData) async {
    final wifiIP = await info.getWifiIP();
    payData.customer?.ip = wifiIP ?? "5.62.60.255";
    var response =
        await _dio.post("/api/payments/create", data: payData.toJson());
    return response;
  }
}
