import 'package:equatable/equatable.dart';
import 'booking_item.dart';

class Booking extends Equatable {
  final String id;
  final String userId;
  final List<BookingItem> items;
  final String status; // pending, confirmed, completed, cancelled, failed
  final String paymentStatus; // pending, completed, failed
  final String paymentMethod; // cash, card, paypal
  final double totalAmount;
  final String createdAt;
  final String updatedAt;
  final String? cancelledAt;

  const Booking({
    required this.id,
    required this.userId,
    required this.items,
    required this.status,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.totalAmount,
    required this.createdAt,
    required this.updatedAt,
    this.cancelledAt,
  });

  bool get canBeCancelled => status != 'completed' && status != 'cancelled';

  @override
  List<Object?> get props => [
    id,
    userId,
    items,
    status,
    paymentStatus,
    paymentMethod,
    totalAmount,
    createdAt,
    updatedAt,
    cancelledAt,
  ];
}