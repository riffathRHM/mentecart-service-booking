import 'package:equatable/equatable.dart';

class BookingItem extends Equatable {
  final String serviceId;
  final String serviceName;
  final double price;
  final String date;
  final String slot;
  final int quantity;

  const BookingItem({
    required this.serviceId,
    required this.serviceName,
    required this.price,
    required this.date,
    required this.slot,
    required this.quantity,
  });

  double get subtotal => price * quantity;

  @override
  List<Object?> get props => [
    serviceId,
    serviceName,
    price,
    date,
    slot,
    quantity,
  ];
}