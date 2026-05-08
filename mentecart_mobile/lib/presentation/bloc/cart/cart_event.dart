import 'package:equatable/equatable.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class GetCartEvent extends CartEvent {
  const GetCartEvent();
}

class AddToCartEvent extends CartEvent {
  final String serviceId;
  final String date;
  final int quantity;

  const AddToCartEvent({
    required this.serviceId,
    required this.date,
    this.quantity = 1,
  });

  @override
  List<Object?> get props => [serviceId, date, quantity];
}

class UpdateCartItemEvent extends CartEvent {
  final String itemId;
  final int quantity;

  const UpdateCartItemEvent({
    required this.itemId,
    required this.quantity,
  });

  @override
  List<Object?> get props => [itemId, quantity];
}

class RemoveFromCartEvent extends CartEvent {
  final String itemId;

  const RemoveFromCartEvent({required this.itemId});

  @override
  List<Object?> get props => [itemId];
}

class ClearCartEvent extends CartEvent {
  const ClearCartEvent();
}