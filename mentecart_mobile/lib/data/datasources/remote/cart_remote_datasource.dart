import 'package:dio/dio.dart';
import 'package:mentecart_mobile/core/network/api_client.dart';
import 'package:mentecart_mobile/core/utils/logger.dart';
import 'package:mentecart_mobile/data/models/cart/cart_model.dart';

abstract class CartRemoteDataSource {
  Future<CartModel> getCart();

  Future<CartModel> addToCart({
    required String serviceId,
    required String date,
    int quantity = 1,
  });

  Future<CartModel> updateCartItem({
    required String itemId,
    int? quantity,
    String? date,
  });

  Future<CartModel> removeFromCart(String itemId);

  Future<void> clearCart();
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final ApiClient apiClient;

  CartRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<CartModel> getCart() async {
    try {
      final response = await apiClient.getCart();

      AppLogger.info('Fetched cart');
      return CartModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      AppLogger.error('Get cart error: ${e.message}');
      throw Exception('Failed to fetch cart: ${e.message}');
    }
  }

  @override
  Future<CartModel> addToCart({
    required String serviceId,
    required String date,
    int quantity = 1,
  }) async {
    try {
      final response = await apiClient.addToCart(
        serviceId: serviceId,
        date: date,
        quantity: quantity,
      );

      AppLogger.info('Added to cart');
      return CartModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      AppLogger.error('Add to cart error: ${e.message}');
      throw Exception('Failed to add to cart: ${e.message}');
    }
  }

  @override
  Future<CartModel> updateCartItem({
    required String itemId,
    int? quantity,
    String? date,
  }) async {
    try {
      final response = await apiClient.updateCartItem(
        itemId: itemId,
        quantity: quantity,
        date: date,
      );

      AppLogger.info('Updated cart item');
      return CartModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      AppLogger.error('Update cart item error: ${e.message}');
      throw Exception('Failed to update cart item: ${e.message}');
    }
  }

  @override
  Future<CartModel> removeFromCart(String itemId) async {
    try {
      final response = await apiClient.removeFromCart(itemId);

      AppLogger.info('Removed from cart');
      return CartModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      AppLogger.error('Remove from cart error: ${e.message}');
      throw Exception('Failed to remove from cart: ${e.message}');
    }
  }

  @override
  Future<void> clearCart() async {
    try {
      AppLogger.info('Cleared cart');
      // Implement if backend supports it
    } on DioException catch (e) {
      AppLogger.error('Clear cart error: ${e.message}');
      throw Exception('Failed to clear cart: ${e.message}');
    }
  }
}