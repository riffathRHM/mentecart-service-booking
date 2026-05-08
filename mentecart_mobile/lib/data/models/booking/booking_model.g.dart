// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingModel _$BookingModelFromJson(Map<String, dynamic> json) => BookingModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => BookingItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] as String,
      paymentStatus: json['paymentStatus'] as String,
      paymentMethod: json['paymentMethod'] as String,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      cancelledAt: json['cancelledAt'] as String?,
    );

Map<String, dynamic> _$BookingModelToJson(BookingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'items': instance.items,
      'status': instance.status,
      'paymentStatus': instance.paymentStatus,
      'paymentMethod': instance.paymentMethod,
      'totalAmount': instance.totalAmount,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'cancelledAt': instance.cancelledAt,
    };
