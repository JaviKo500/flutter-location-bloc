import 'package:dio/dio.dart';
const accessToken = 'pk.eyJ1IjoiamF2aWtvIiwiYSI6ImNsMjRucTB2YTIyMmQza3BkbmR4cnY0a3kifQ.vKSFkpQ_xMNVBkqv79B2Uw';
class TrafficInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters.addAll({
      'alternatives': true,
      'geometries': 'polyline6',
      'overview': 'simplified',
      'steps': false,
      'access_token': accessToken
    });
    super.onRequest(options, handler);
  }
}