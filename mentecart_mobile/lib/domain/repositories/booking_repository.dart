import 'package:dartz/dartz.dart';
import 'package:mentecart_mobile/core/errors/failures.dart';
import 'package:mentecart_mobile/domain/entities/booking/booking.dart';

abstract class BookingRepository {
  Future<Either<Failure, Booking>> checkout({
    required String paymentMethod,
    Map<String, dynamic>? address,
  });

  Future<Either<Failure, List<Booking>>> getBookings();

  Future<Either<Failure, Booking>> getBookingById(String id);

  Future<Either<Failure, void>> cancelBooking(
    String id, {
    String? reason,
  });
}