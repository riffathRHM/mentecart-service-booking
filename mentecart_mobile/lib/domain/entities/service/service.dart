import 'package:equatable/equatable.dart';

class Service extends Equatable {
  final String id;
  final String title;
  final String description;
  final double price;
  final int duration;
  final String category;
  final int capacityPerSlot;
  final String? image;
  final bool isActive;

  const Service({
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

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    price,
    duration,
    category,
    capacityPerSlot,
    image,
    isActive,
  ];
}