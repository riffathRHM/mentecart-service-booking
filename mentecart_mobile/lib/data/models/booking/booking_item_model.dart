import 'package:json_annotation/json_annotation.dart';
import 'package:mentecart_mobile/domain/entities/booking/booking_item.dart';

part 'booking_item_model.g.dart';

@JsonSerializable()
class BookingItemModel {
  final String serviceId;
  final String serviceName;
  final double price;
  final String date;
  final String slot;
  final int quantity;

  BookingItemModel({
    required this.serviceId,
    required this.serviceName,
    required this.price,
    required this.date,
    required this.slot,
    required this.quantity,
  });

  factory BookingItemModel.fromJson(Map<String, dynamic> json) =>
      _$BookingItemModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$BookingItemModelToJson(this);

  BookingItem toDomain() {
    return BookingItem(
      serviceId: serviceId,
      serviceName: serviceName,
      price: price,
      date: date,
      slot: slot,
      quantity: quantity,
    );
  }
}