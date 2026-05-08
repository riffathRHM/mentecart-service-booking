// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingItemModel _$BookingItemModelFromJson(Map<String, dynamic> json) =>
    BookingItemModel(
      serviceId: json['serviceId'] as String,
      serviceName: json['serviceName'] as String,
      price: (json['price'] as num).toDouble(),
      date: json['date'] as String,
      slot: json['slot'] as String,
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$BookingItemModelToJson(BookingItemModel instance) =>
    <String, dynamic>{
      'serviceId': instance.serviceId,
      'serviceName': instance.serviceName,
      'price': instance.price,
      'date': instance.date,
      'slot': instance.slot,
      'quantity': instance.quantity,
    };
