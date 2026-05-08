import 'package:equatable/equatable.dart';
import 'cart_item.dart';

class Cart extends Equatable {
  final String id;
  final String userId;
  final List<CartItem> items;
  final double totalAmount;

  const Cart({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
  });

  int get itemCount => items.length;

  double get totalPrice => items.fold(
    0.0,
    (sum, item) => sum + (item.price * item.quantity),
  );

  @override
  List<Object?> get props => [id, userId, items, totalAmount];
}