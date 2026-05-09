// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceModel _$ServiceModelFromJson(Map<String, dynamic> json) => ServiceModel(
      id: json['_id'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      duration: (json['duration'] as num?)?.toInt(),
      category: json['category'] as String?,
      capacityPerSlot: (json['capacityPerSlot'] as num?)?.toInt(),
      image: json['image'] as String?,
      isActive: json['isActive'] as bool?,
    );

Map<String, dynamic> _$ServiceModelToJson(ServiceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'price': instance.price,
      'duration': instance.duration,
      'category': instance.category,
      'capacityPerSlot': instance.capacityPerSlot,
      'image': instance.image,
      'isActive': instance.isActive,
    };
