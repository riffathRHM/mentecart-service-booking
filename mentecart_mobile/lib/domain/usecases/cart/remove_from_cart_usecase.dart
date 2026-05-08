import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mentecart_mobile/core/errors/failures.dart';
import 'package:mentecart_mobile/domain/entities/cart/cart.dart';
import 'package:mentecart_mobile/domain/repositories/cart_repository.dart';
import '../usecase.dart';

class RemoveFromCartUsecase extends UseCase<Cart, RemoveFromCartParams> {
  final CartRepository repository;

  RemoveFromCartUsecase({required this.repository});

  @override
  Future<Either<Failure, Cart>> call(RemoveFromCartParams params) async {
    return await repository.removeFromCart(params.itemId);
  }
}

class RemoveFromCartParams extends Equatable {
  final String itemId;

  const RemoveFromCartParams({required this.itemId});

  @override
  List<Object?> get props => [itemId];
}