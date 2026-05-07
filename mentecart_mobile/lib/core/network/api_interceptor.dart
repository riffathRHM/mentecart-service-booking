import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import '../utils/logger.dart';

class ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final box = Hive.box('auth');
    final token = box.get('access_token');

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    AppLogger.info('API Request: ${options.method} ${options.path}');
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      AppLogger.warning('Unauthorized - Token might be expired');
      // Handle logout here
    }
    AppLogger.error('API Error: ${err.message}');
    super.onError(err, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.info('API Response: ${response.statusCode} ${response.requestOptions.path}');
    super.onResponse(response, handler);
  }
}