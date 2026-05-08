import 'package:dio/dio.dart';
import 'package:mentecart_mobile/core/network/api_client.dart';
import 'package:mentecart_mobile/core/utils/logger.dart';
import 'package:mentecart_mobile/data/models/booking/booking_model.dart';

abstract class BookingRemoteDataSource {
  Future<BookingModel> checkout({
    required String paymentMethod,
    Map<String, dynamic>? address,
  });

  Future<List<BookingModel>> getBookings();

  Future<BookingModel> getBookingById(String id);

  Future<void> cancelBooking(String id, {String? reason});
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final ApiClient apiClient;

  BookingRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<BookingModel> checkout({
    required String paymentMethod,
    Map<String, dynamic>? address,
  }) async {
    try {
      final response = await apiClient.checkout(
        paymentMethod: paymentMethod,
        address: address,
      );

      AppLogger.info('Checkout successful');
      return BookingModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      AppLogger.error('Checkout error: ${e.message}');
      throw Exception('Failed to checkout: ${e.message}');
    }
  }

  @override
  Future<List<BookingModel>> getBookings() async {
    try {
      final response = await apiClient.getBookings();

      final List<dynamic> data = response.data['data']['bookings'] ?? [];
      AppLogger.info('Fetched ${data.length} bookings');

      return data
          .map((booking) => BookingModel.fromJson(booking as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      AppLogger.error('Get bookings error: ${e.message}');
      throw Exception('Failed to fetch bookings: ${e.message}');
    }
  }

  @override
  Future<BookingModel> getBookingById(String id) async {
    try {
      final response = await apiClient.getBookingById(id);

      AppLogger.info('Fetched booking: $id');
      return BookingModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      AppLogger.error('Get booking error: ${e.message}');
      throw Exception('Failed to fetch booking: ${e.message}');
    }
  }

  @override
  Future<void> cancelBooking(String id, {String? reason}) async {
    try {
      await apiClient.cancelBooking(id, reason: reason);

      AppLogger.info('Cancelled booking: $id');
    } on DioException catch (e) {
      AppLogger.error('Cancel booking error: ${e.message}');
      throw Exception('Failed to cancel booking: ${e.message}');
    }
  }
}