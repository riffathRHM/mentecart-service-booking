import 'package:equatable/equatable.dart';

class CartItem extends Equatable {
  final String id;
  final String serviceId;
  final String serviceName;
  final double price;
  final String date;
  final String slot;
  final int quantity;
  final DateTime expiresAt;

  const CartItem({
    required this.id,
    required this.serviceId,
    required this.serviceName,
    required this.price,
    required this.date,
    required this.slot,
    required this.quantity,
    required this.expiresAt,
  });

  double get subtotal => price * quantity;

  @override
  List<Object?> get props => [
    id,
    serviceId,
    serviceName,
    price,
    date,
    slot,
    quantity,
    expiresAt,
  ];
}