// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartItemModel _$CartItemModelFromJson(Map<String, dynamic> json) =>
    CartItemModel(
      id: json['id'] as String,
      serviceId: json['serviceId'] as String,
      serviceName: json['serviceName'] as String,
      price: (json['price'] as num).toDouble(),
      date: json['date'] as String,
      slot: json['slot'] as String,
      quantity: (json['quantity'] as num).toInt(),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
    );

Map<String, dynamic> _$CartItemModelToJson(CartItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'serviceId': instance.serviceId,
      'serviceName': instance.serviceName,
      'price': instance.price,
      'date': instance.date,
      'slot': instance.slot,
      'quantity': instance.quantity,
      'expiresAt': instance.expiresAt.toIso8601String(),
    };
