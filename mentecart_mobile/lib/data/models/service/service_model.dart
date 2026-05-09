import 'package:json_annotation/json_annotation.dart';
import 'package:mentecart_mobile/domain/entities/service/service.dart';

part 'service_model.g.dart';

@JsonSerializable()
class ServiceModel {
  @JsonKey(name: '_id')
  final String? id;
  final String? title;
  final String? description;
  final double? price;
  final int? duration;
  final String? category;
  @JsonKey(name: 'capacityPerSlot')
  final int? capacityPerSlot;
  final String? image;
  final bool? isActive;

  ServiceModel({
    this.id,
    this.title,
    this.description,
    this.price,
    this.duration,
    this.category,
    this.capacityPerSlot,
    this.image,
    this.isActive,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceModelFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceModelToJson(this);

  Service toDomain() => Service(
    id: id ?? '',
    title: title ?? 'Unknown',
    description: description ?? '',
    price: price ?? 0.0,
    duration: duration ?? 0,
    category: category ?? 'Other',
    capacityPerSlot: capacityPerSlot ?? 1,
    image: image,
    isActive: isActive ?? true,
  );
}