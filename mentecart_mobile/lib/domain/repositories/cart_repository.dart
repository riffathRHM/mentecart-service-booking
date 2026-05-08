import 'package:dartz/dartz.dart';
import 'package:mentecart_mobile/core/errors/failures.dart';
import 'package:mentecart_mobile/domain/entities/cart/cart.dart';

abstract class CartRepository {
  Future<Either<Failure, Cart>> getCart();

  Future<Either<Failure, Cart>> addToCart({
    required String serviceId,
    required String date,
    int quantity = 1,
  });

  Future<Either<Failure, Cart>> updateCartItem({
    required String itemId,
    int? quantity,
    String? date,
  });

  Future<Either<Failure, Cart>> removeFromCart(String itemId);

  Future<Either<Failure, void>> clearCart();
}