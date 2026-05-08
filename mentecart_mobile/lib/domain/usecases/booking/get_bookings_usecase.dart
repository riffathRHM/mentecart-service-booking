import 'package:dartz/dartz.dart';
import 'package:mentecart_mobile/core/errors/failures.dart';
import 'package:mentecart_mobile/domain/entities/booking/booking.dart';
import 'package:mentecart_mobile/domain/repositories/booking_repository.dart';
import '../usecase.dart';

class GetBookingsUsecase extends UseCase<List<Booking>, NoParams> {
  final BookingRepository repository;

  GetBookingsUsecase({required this.repository});

  @override
  Future<Either<Failure, List<Booking>>> call(NoParams params) async {
    return await repository.getBookings();
  }
}