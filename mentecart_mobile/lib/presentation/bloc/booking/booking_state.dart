import 'package:equatable/equatable.dart';
import 'package:mentecart_mobile/domain/entities/booking/booking.dart';

abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object?> get props => [];
}

class BookingInitial extends BookingState {
  const BookingInitial();
}

class BookingLoading extends BookingState {
  const BookingLoading();
}

class BookingsLoaded extends BookingState {
  final List<Booking> bookings;

  const BookingsLoaded({required this.bookings});

  @override
  List<Object?> get props => [bookings];
}

class BookingSuccess extends BookingState {
  final String bookingId;

  const BookingSuccess({required this.bookingId});

  @override
  List<Object?> get props => [bookingId];
}

class BookingError extends BookingState {
  final String message;

  const BookingError(this.message);

  @override
  List<Object?> get props => [message];
}