import 'package:dio/dio.dart';
import 'package:mentecart_mobile/core/network/api_client.dart';
import 'package:mentecart_mobile/core/utils/logger.dart';
import 'package:mentecart_mobile/data/models/service/service_model.dart';
abstract class ServiceRemoteDataSource {
  Future<List<ServiceModel>> getServices({
    int page = 1,
    int limit = 20,
    String? category,
    String? search,
  });

  Future<ServiceModel> getServiceById(String id);

  Future<ServiceModel> getServiceWithSlots(String id);
}

class ServiceRemoteDataSourceImpl implements ServiceRemoteDataSource {
  final ApiClient apiClient;

  ServiceRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<ServiceModel>> getServices({
    int page = 1,
    int limit = 20,
    String? category,
    String? search,
  }) async {
    try {
      final response = await apiClient.getServices(
        page: page,
        limit: limit,
        category: category,
        search: search,
      );

      final List<dynamic> data = response.data['data']['services'] ?? [];
      AppLogger.info('Fetched ${data.length} services');

      return data
          .map((service) => ServiceModel.fromJson(service as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      AppLogger.error('Get services error: ${e.message}');
      throw Exception('Failed to fetch services: ${e.message}');
    }
  }

  @override
  Future<ServiceModel> getServiceById(String id) async {
    try {
      final response = await apiClient.getServiceById(id);

      AppLogger.info('Fetched service: $id');
      return ServiceModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      AppLogger.error('Get service error: ${e.message}');
      throw Exception('Failed to fetch service: ${e.message}');
    }
  }

  @override
  Future<ServiceModel> getServiceWithSlots(String id) async {
    try {
      final response = await apiClient.getServiceSlots(id);

      AppLogger.info('Fetched service with slots: $id');
      return ServiceModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      AppLogger.error('Get service slots error: ${e.message}');
      throw Exception('Failed to fetch service slots: ${e.message}');
    }
  }
}