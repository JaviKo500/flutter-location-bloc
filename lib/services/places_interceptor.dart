import 'package:dio/dio.dart';


class PlacesInterceptor extends Interceptor {
  final accessToken = 'pk.eyJ1IjoiamF2aWtvIiwiYSI6ImNsMjRucTB2YTIyMmQza3BkbmR4cnY0a3kifQ.vKSFkpQ_xMNVBkqv79B2Uw';
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters.addAll({
      'access_token': accessToken,
      'language': 'es',
      'country': 'ec',
      'types': 'address,place,poi',
    });
    super.onRequest(options, handler);
  }
}