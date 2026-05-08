import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mentecart_mobile/core/errors/failures.dart';
import 'package:mentecart_mobile/domain/entities/cart/cart.dart';
import 'package:mentecart_mobile/domain/repositories/cart_repository.dart';
import '../usecase.dart';

class AddToCartUsecase extends UseCase<Cart, AddToCartParams> {
  final CartRepository repository;

  AddToCartUsecase({required this.repository});

  @override
  Future<Either<Failure, Cart>> call(AddToCartParams params) async {
    return await repository.addToCart(
      serviceId: params.serviceId,
      date: params.date,
      quantity: params.quantity,
    );
  }
}

class AddToCartParams extends Equatable {
  final String serviceId;
  final String date;
  final int quantity;

  const AddToCartParams({
    required this.serviceId,
    required this.date,
    this.quantity = 1,
  });

  @override
  List<Object?> get props => [serviceId, date, quantity];
}