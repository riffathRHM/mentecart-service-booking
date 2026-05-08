import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mentecart_mobile/core/errors/failures.dart';
import 'package:mentecart_mobile/domain/entities/cart/cart.dart';
import 'package:mentecart_mobile/domain/repositories/cart_repository.dart';
import '../usecase.dart';

class UpdateCartItemUsecase extends UseCase<Cart, UpdateCartItemParams> {
  final CartRepository repository;

  UpdateCartItemUsecase({required this.repository});

  @override
  Future<Either<Failure, Cart>> call(UpdateCartItemParams params) async {
    return await repository.updateCartItem(
      itemId: params.itemId,
      quantity: params.quantity,
      date: params.date,
    );
  }
}

class UpdateCartItemParams extends Equatable {
  final String itemId;
  final int? quantity;
  final String? date;

  const UpdateCartItemParams({
    required this.itemId,
    this.quantity,
    this.date,
  });

  @override
  List<Object?> get props => [itemId, quantity, date];
}