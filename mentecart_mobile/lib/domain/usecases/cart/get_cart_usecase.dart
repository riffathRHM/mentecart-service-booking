import 'package:dartz/dartz.dart';
import 'package:mentecart_mobile/core/errors/failures.dart';
import 'package:mentecart_mobile/domain/entities/cart/cart.dart';
import 'package:mentecart_mobile/domain/repositories/cart_repository.dart';
import '../usecase.dart';

class GetCartUsecase extends UseCase<Cart, NoParams> {
  final CartRepository repository;

  GetCartUsecase({required this.repository});

  @override
  Future<Either<Failure, Cart>> call(NoParams params) async {
    return await repository.getCart();
  }
}