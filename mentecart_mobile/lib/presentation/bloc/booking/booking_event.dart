import 'package:equatable/equatable.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object?> get props => [];
}

class GetBookingsEvent extends BookingEvent {
  const GetBookingsEvent();
}

class CheckoutEvent extends BookingEvent {
  final String paymentMethod;
  final Map<String, dynamic>? address;

  const CheckoutEvent({
    required this.paymentMethod,
    this.address,
  });

  @override
  List<Object?> get props => [paymentMethod, address];
}

class CancelBookingEvent extends BookingEvent {
  final String bookingId;
  final String? reason;

  const CancelBookingEvent({
    required this.bookingId,
    this.reason,
  });

  @override
  List<Object?> get props => [bookingId, reason];
}