import 'package:json_annotation/json_annotation.dart';
import 'package:mentecart_mobile/domain/entities/booking/booking.dart';
import 'booking_item_model.dart';

part 'booking_model.g.dart';

@JsonSerializable()
class BookingModel {
  final String id;
  final String userId;
  final List<BookingItemModel> items;
  final String status;
  final String paymentStatus;
  final String paymentMethod;
  final double totalAmount;
  final String createdAt;
  final String updatedAt;
  final String? cancelledAt;

  BookingModel({
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

  factory BookingModel.fromJson(Map<String, dynamic> json) =>
      _$BookingModelFromJson(json);

  Map<String, dynamic> toJson() => _$BookingModelToJson(this);

  Booking toDomain() => Booking(
    id: id,
    userId: userId,
    items: items.map((item) => item.toDomain()).toList(),
    status: status,
    paymentStatus: paymentStatus,
    paymentMethod: paymentMethod,
    totalAmount: totalAmount,
    createdAt: createdAt,
    updatedAt: updatedAt,
    cancelledAt: cancelledAt,
  );
}