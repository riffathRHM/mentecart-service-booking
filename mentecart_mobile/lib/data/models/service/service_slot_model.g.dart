// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_slot_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceSlotModel _$ServiceSlotModelFromJson(Map<String, dynamic> json) =>
    ServiceSlotModel(
      id: json['id'] as String,
      serviceId: json['serviceId'] as String,
      date: DateTime.parse(json['date'] as String),
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      totalCapacity: (json['totalCapacity'] as num).toInt(),
      bookedCapacity: (json['bookedCapacity'] as num).toInt(),
      availableCapacity: (json['availableCapacity'] as num).toInt(),
      isActive: json['isActive'] as bool,
    );

Map<String, dynamic> _$ServiceSlotModelToJson(ServiceSlotModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'serviceId': instance.serviceId,
      'date': instance.date.toIso8601String(),
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'totalCapacity': instance.totalCapacity,
      'bookedCapacity': instance.bookedCapacity,
      'availableCapacity': instance.availableCapacity,
      'isActive': instance.isActive,
    };
