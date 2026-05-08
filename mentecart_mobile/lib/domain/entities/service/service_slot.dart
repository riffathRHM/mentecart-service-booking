import 'package:equatable/equatable.dart';

class ServiceSlot extends Equatable {
  final String id;
  final String serviceId;
  final DateTime date;
  final String startTime;
  final String endTime;
  final int totalCapacity;
  final int bookedCapacity;
  final int availableCapacity;
  final bool isActive;

  const ServiceSlot({
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

  @override
  List<Object?> get props => [
    id,
    serviceId,
    date,
    startTime,
    endTime,
    totalCapacity,
    bookedCapacity,
    availableCapacity,
    isActive,
  ];
}