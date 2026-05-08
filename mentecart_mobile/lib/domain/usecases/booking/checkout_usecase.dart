import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mentecart_mobile/core/errors/failures.dart';
import 'package:mentecart_mobile/domain/entities/booking/booking.dart';
import 'package:mentecart_mobile/domain/repositories/booking_repository.dart';
import '../usecase.dart';

class CheckoutUsecase extends UseCase<Booking, CheckoutParams> {
  final BookingRepository repository;

  CheckoutUsecase({required this.repository});

  @override
  Future<Either<Failure, Booking>> call(CheckoutParams params) async {
    return await repository.checkout(
      paymentMethod: params.paymentMethod,
      address: params.address,
    );
  }
}

class CheckoutParams extends Equatable {
  final String paymentMethod;
  final Map<String, dynamic>? address;

  const CheckoutParams({
    required this.paymentMethod,
    this.address,
  });

  @override
  List<Object?> get props => [paymentMethod, address];
}