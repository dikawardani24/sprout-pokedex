import 'package:flutter/foundation.dart';
import 'package:http_interceptor/http_interceptor.dart';

class LoggingInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    if (kDebugMode) {
      print('=== Request ===');
      print('URL: ${data.url}');
      print('Headers: ${data.headers}');
      print('Body: ${data.body}');
      print('Method: ${data.method}');
    }
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    if (kDebugMode) {
      print('=== Response ===');
      print('URL: ${data.url}');
      print('Status: ${data.statusCode}');
      print('Headers: ${data.headers}');
      print('Body: ${data.body}');
    }
    return data;
  }
}