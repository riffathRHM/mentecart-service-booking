import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentecart_mobile/core/utils/logger.dart';
import 'package:mentecart_mobile/domain/usecases/booking/cancel_booking_usecase.dart';
import 'package:mentecart_mobile/domain/usecases/booking/checkout_usecase.dart';
import 'package:mentecart_mobile/domain/usecases/booking/get_bookings_usecase.dart';
import 'package:mentecart_mobile/domain/usecases/usecase.dart';
import 'booking_event.dart';
import 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final CheckoutUsecase checkoutUsecase;
  final GetBookingsUsecase getBookingsUsecase;
  final CancelBookingUsecase cancelBookingUsecase;

  BookingBloc({
    required this.checkoutUsecase,
    required this.getBookingsUsecase,
    required this.cancelBookingUsecase,
  }) : super(const BookingInitial()) {
    on<GetBookingsEvent>(_onGetBookings);
    on<CheckoutEvent>(_onCheckout);
    on<CancelBookingEvent>(_onCancelBooking);
  }

  Future<void> _onGetBookings(
    GetBookingsEvent event,
    Emitter<BookingState> emit,
  ) async {
    emit(const BookingLoading());

    try {
      final result = await getBookingsUsecase(const NoParams());

      result.fold(
        (failure) => emit(BookingError(failure.message)),
        (bookings) {
          AppLogger.info('Loaded ${bookings.length} bookings');
          emit(BookingsLoaded(bookings: bookings));
        },
      );
    } catch (e) {
      AppLogger.error('Get bookings error: $e');
      emit(BookingError('Failed to load bookings'));
    }
  }

  Future<void> _onCheckout(
    CheckoutEvent event,
    Emitter<BookingState> emit,
  ) async {
    emit(const BookingLoading());

    try {
      final result = await checkoutUsecase(
        CheckoutParams(
          paymentMethod: event.paymentMethod,
          address: event.address,
        ),
      );

      result.fold(
        (failure) => emit(BookingError(failure.message)),
        (booking) {
          AppLogger.info('Checkout successful: ${booking.id}');
          emit(BookingSuccess(bookingId: booking.id));
        },
      );
    } catch (e) {
      AppLogger.error('Checkout error: $e');
      emit(BookingError('Failed to complete booking'));
    }
  }

  Future<void> _onCancelBooking(
    CancelBookingEvent event,
    Emitter<BookingState> emit,
  ) async {
    emit(const BookingLoading());

    try {
      final result = await cancelBookingUsecase(
        CancelBookingParams(
          bookingId: event.bookingId,
          reason: event.reason,
        ),
      );

      result.fold(
        (failure) => emit(BookingError(failure.message)),
        (_) {
          AppLogger.info('Booking cancelled: ${event.bookingId}');
          // Reload bookings after cancellation
          add(const GetBookingsEvent());
        },
      );
    } catch (e) {
      AppLogger.error('Cancel booking error: $e');
      emit(BookingError('Failed to cancel booking'));
    }
  }
}