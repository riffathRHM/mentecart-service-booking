import 'package:dartz/dartz.dart';
import 'package:mentecart_mobile/core/errors/failures.dart';
import 'package:mentecart_mobile/data/datasources/remote/cart_remote_datasource.dart';
import 'package:mentecart_mobile/domain/entities/cart/cart.dart';
import 'package:mentecart_mobile/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;

  CartRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Cart>> getCart() async {
    try {
      final result = await remoteDataSource.getCart();
      return Right(result.toDomain());
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Cart>> addToCart({
    required String serviceId,
    required String date,
    int quantity = 1,
  }) async {
    try {
      final result = await remoteDataSource.addToCart(
        serviceId: serviceId,
        date: date,
        quantity: quantity,
      );

      return Right(result.toDomain());
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Cart>> updateCartItem({
    required String itemId,
    int? quantity,
    String? date,
  }) async {
    try {
      final result = await remoteDataSource.updateCartItem(
        itemId: itemId,
        quantity: quantity,
        date: date,
      );

      return Right(result.toDomain());
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Cart>> removeFromCart(String itemId) async {
    try {
      final result = await remoteDataSource.removeFromCart(itemId);
      return Right(result.toDomain());
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearCart() async {
    try {
      await remoteDataSource.clearCart();
      return const Right(null);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}