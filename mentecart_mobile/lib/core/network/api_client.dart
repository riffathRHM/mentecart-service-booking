import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../config/environment.dart';
import 'api_interceptor.dart';

class ApiClient {
  late Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: Environment.backendBaseUrl,
        connectTimeout: Duration(seconds: Environment.apiTimeout),
        receiveTimeout: Duration(seconds: Environment.apiTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(ApiInterceptor());

    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          error: true,
          logPrint: (obj) => debugPrint(obj.toString()),
        ),
      );
    }
  }

  Dio get dio => _dio;

  // AUTH ENDPOINTS
  Future<Response> signup({
    required String name,
    required String email,
    required String password,
  }) {
    return _dio.post(
      '/auth/signup',
      data: {
        'name': name,
        'email': email,
        'password': password,
      },
    );
  }

  Future<Response> login({
    required String email,
    required String password,
  }) {
    return _dio.post(
      '/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );
  }

  Future<Response> getCurrentUser() => _dio.get('/auth/me');

  // SERVICE ENDPOINTS
  Future<Response> getServices({
    int page = 1,
    int limit = 20,
    String? category,
    String? search,
  }) {
    return _dio.get(
      '/services',
      queryParameters: {
        'page': page,
        'limit': limit,
        if (category != null) 'category': category,
        if (search != null) 'search': search,
      },
    );
  }

  Future<Response> getServiceById(String id) => _dio.get('/services/$id');

  Future<Response> getServiceSlots(String id) => _dio.get('/services/$id/slots');

  // CART ENDPOINTS
  Future<Response> getCart() => _dio.get('/cart');

  Future<Response> addToCart({
    required String serviceId,
    required String date,
    int quantity = 1,
  }) {
    return _dio.post(
      '/cart/items',
      data: {
        'serviceId': serviceId,
        'date': date,
        'quantity': quantity,
      },
    );
  }

  Future<Response> updateCartItem({
    required String itemId,
    int? quantity,
    String? date,
  }) {
    return _dio.patch(
      '/cart/items/$itemId',
      data: {
        if (quantity != null) 'quantity': quantity,
        if (date != null) 'date': date,
      },
    );
  }

  Future<Response> removeFromCart(String itemId) =>
      _dio.delete('/cart/items/$itemId');

  // BOOKING ENDPOINTS
  Future<Response> checkout({
    String paymentMethod = 'cash',
    Map<String, dynamic>? address,
  }) {
    return _dio.post(
      '/bookings/checkout',
      data: {
        'paymentMethod': paymentMethod,
        if (address != null) 'address': address,
      },
    );
  }

  Future<Response> getBookings() => _dio.get('/bookings');

  Future<Response> getBookingById(String id) => _dio.get('/bookings/$id');

  Future<Response> cancelBooking(String id, {String? reason}) {
    return _dio.post(
      '/bookings/$id/cancel',
      data: {
        if (reason != null) 'reason': reason,
      },
    );
  }
}