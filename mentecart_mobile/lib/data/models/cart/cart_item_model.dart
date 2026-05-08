import 'package:json_annotation/json_annotation.dart';
import 'package:mentecart_mobile/domain/entities/cart/cart_item.dart';

part 'cart_item_model.g.dart';

@JsonSerializable()
class CartItemModel {
  final String id;
  final String serviceId;
  final String serviceName;
  final double price;
  final String date;
  final String slot;
  final int quantity;
  final DateTime expiresAt;

  CartItemModel({
    required this.id,
    required this.serviceId,
    required this.serviceName,
    required this.price,
    required this.date,
    required this.slot,
    required this.quantity,
    required this.expiresAt,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) =>
      _$CartItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$CartItemModelToJson(this);

  CartItem toDomain() => CartItem(
    id: id,
    serviceId: serviceId,
    serviceName: serviceName,
    price: price,
    date: date,
    slot: slot,
    quantity: quantity,
    expiresAt: expiresAt,
  );
}