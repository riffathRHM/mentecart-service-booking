import 'package:dartz/dartz.dart';
import 'package:mentecart_mobile/core/errors/failures.dart';
import 'package:mentecart_mobile/data/datasources/remote/booking_remote_datasource.dart';
import 'package:mentecart_mobile/domain/entities/booking/booking.dart';
import 'package:mentecart_mobile/domain/repositories/booking_repository.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource remoteDataSource;

  BookingRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, Booking>> checkout({
    required String paymentMethod,
    Map<String, dynamic>? address,
  }) async {
    try {
      final result = await remoteDataSource.checkout(
        paymentMethod: paymentMethod,
        address: address,
      );

      return Right(result.toDomain());
    } catch (e) {
      if (e.toString().contains('409')) {
        return Left(ConflictFailure(e.toString()));
      }

      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Booking>>> getBookings() async {
    try {
      final result = await remoteDataSource.getBookings();

      final bookings = result
          .map((model) => model.toDomain())
          .toList();

      return Right(bookings);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Booking>> getBookingById(
    String id,
  ) async {
    try {
      final result = await remoteDataSource.getBookingById(id);

      return Right(result.toDomain());
    } catch (e) {
      return Left(NotFoundFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> cancelBooking(
    String id, {
    String? reason,
  }) async {
    try {
      await remoteDataSource.cancelBooking(
        id,
        reason: reason,
      );

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}