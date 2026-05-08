import 'package:equatable/equatable.dart';

abstract class ServiceEvent extends Equatable {
  const ServiceEvent();

  @override
  List<Object?> get props => [];
}

class GetServicesEvent extends ServiceEvent {
  final int page;
  final int limit;
  final String? category;
  final String? search;

  const GetServicesEvent({
    this.page = 1,
    this.limit = 20,
    this.category,
    this.search,
  });

  @override
  List<Object?> get props => [page, limit, category, search];
}

class GetServiceDetailEvent extends ServiceEvent {
  final String serviceId;

  const GetServiceDetailEvent({required this.serviceId});

  @override
  List<Object?> get props => [serviceId];
}