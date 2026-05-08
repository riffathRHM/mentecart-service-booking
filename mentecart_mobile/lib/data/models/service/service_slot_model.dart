import 'package:json_annotation/json_annotation.dart';
import 'package:mentecart_mobile/domain/entities/service/service_slot.dart';

part 'service_slot_model.g.dart';

@JsonSerializable()
class ServiceSlotModel {
  final String id;
  final String serviceId;
  final DateTime date;
  final String startTime;
  final String endTime;
  final int totalCapacity;
  final int bookedCapacity;
  final int availableCapacity;
  final bool isActive;

  ServiceSlotModel({
    required this.id,
    required this.serviceId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.totalCapacity,
    required this.bookedCapacity,
    required this.availableCapacity,
    required this.isActive,
  });

  factory ServiceSlotModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceSlotModelFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceSlotModelToJson(this);

  ServiceSlot toDomain() => ServiceSlot(
    id: id,
    serviceId: serviceId,
    date: date,
    startTime: startTime,
    endTime: endTime,
    totalCapacity: totalCapacity,
    bookedCapacity: bookedCapacity,
    availableCapacity: availableCapacity,
    isActive: isActive,
  );
}