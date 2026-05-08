import 'package:dio/dio.dart';
import 'package:mentecart_mobile/core/network/api_client.dart';
import 'package:mentecart_mobile/core/utils/logger.dart';
import 'package:mentecart_mobile/data/models/auth/auth_response_model.dart';
import 'package:mentecart_mobile/data/models/auth/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> signup({
    required String name,
    required String email,
    required String password,
  });

  Future<AuthResponseModel> login({
    required String email,
    required String password,
  });

  Future<UserModel> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<AuthResponseModel> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await apiClient.signup(
        name: name,
        email: email,
        password: password,
      );

      AppLogger.info('Signup successful');
      return AuthResponseModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      AppLogger.error('Signup error: ${e.message}');
      throw _handleDioException(e);
    }
  }

  @override
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await apiClient.login(
        email: email,
        password: password,
      );

      AppLogger.info('Login successful');
      return AuthResponseModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      AppLogger.error('Login error: ${e.message}');
      throw _handleDioException(e);
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await apiClient.getCurrentUser();

      AppLogger.info('Get current user successful');
      return UserModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      AppLogger.error('Get current user error: ${e.message}');
      throw _handleDioException(e);
    }
  }

  Exception _handleDioException(DioException e) {
    if (e.response != null) {
      final errorData = e.response!.data;
      final message = errorData['message'] ?? 'An error occurred';
      final errorCode = errorData['errorCode'];

      return Exception('$message (Code: $errorCode)');
    }
    return Exception('Network error: ${e.message}');
  }
}