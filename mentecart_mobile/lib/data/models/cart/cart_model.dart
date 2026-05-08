import 'package:json_annotation/json_annotation.dart';
import 'package:mentecart_mobile/domain/entities/cart/cart.dart';
import 'cart_item_model.dart';

part 'cart_model.g.dart';

@JsonSerializable()
class CartModel {
  final String id;
  final String userId;
  final List<CartItemModel> items;
  final double totalAmount;

  CartModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) =>
      _$CartModelFromJson(json);

  Map<String, dynamic> toJson() => _$CartModelToJson(this);

  Cart toDomain() => Cart(
    id: id,
    userId: userId,
    items: items.map((item) => item.toDomain()).toList(),
    totalAmount: totalAmount,
  );
}