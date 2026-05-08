import 'package:equatable/equatable.dart';
import 'package:mentecart_mobile/domain/entities/service/service.dart';

abstract class ServiceState extends Equatable {
  const ServiceState();

  @override
  List<Object?> get props => [];
}

class ServiceInitial extends ServiceState {
  const ServiceInitial();
}

class ServiceLoading extends ServiceState {
  const ServiceLoading();
}

class ServicesLoaded extends ServiceState {
  final List<Service> services;
  final int total;
  final bool hasMore;

  const ServicesLoaded({
    required this.services,
    required this.total,
    required this.hasMore,
  });

  @override
  List<Object?> get props => [services, total, hasMore];
}

class ServiceDetailLoaded extends ServiceState {
  final Service service;

  const ServiceDetailLoaded({required this.service});

  @override
  List<Object?> get props => [service];
}

class ServiceError extends ServiceState {
  final String message;

  const ServiceError(this.message);

  @override
  List<Object?> get props => [message];
}