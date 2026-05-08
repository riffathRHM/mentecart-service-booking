import 'package:json_annotation/json_annotation.dart';
import 'package:mentecart_mobile/domain/entities/service/service.dart';

part 'service_model.g.dart';

@JsonSerializable()
class ServiceModel {
  final String id;
  final String title;
  final String description;
  final double price;
  final int duration;
  final String category;
  @JsonKey(name: 'capacityPerSlot')
  final int capacityPerSlot;
  final String? image;
  final bool isActive;

  ServiceModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.duration,
    required this.category,
    required this.capacityPerSlot,
    this.image,
    required this.isActive,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceModelFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceModelToJson(this);

  Service toDomain() => Service(
    id: id,
    title: title,
    description: description,
    price: price,
    duration: duration,
    category: category,
    capacityPerSlot: capacityPerSlot,
    image: image,
    isActive: isActive,
  );
}