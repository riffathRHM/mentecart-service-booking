import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mentecart_mobile/core/errors/failures.dart';
import 'package:mentecart_mobile/domain/repositories/booking_repository.dart';
import '../usecase.dart';

class CancelBookingUsecase extends UseCase<void, CancelBookingParams> {
  final BookingRepository repository;

  CancelBookingUsecase({required this.repository});

  @override
  Future<Either<Failure, void>> call(CancelBookingParams params) async {
    return await repository.cancelBooking(
      params.bookingId,
      reason: params.reason,
    );
  }
}

class CancelBookingParams extends Equatable {
  final String bookingId;
  final String? reason;

  const CancelBookingParams({
    required this.bookingId,
    this.reason,
  });

  @override
  List<Object?> get props => [bookingId, reason];
}