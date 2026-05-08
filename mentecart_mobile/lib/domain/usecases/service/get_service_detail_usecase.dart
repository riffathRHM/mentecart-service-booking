import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mentecart_mobile/core/errors/failures.dart';
import 'package:mentecart_mobile/domain/entities/service/service.dart';
import 'package:mentecart_mobile/domain/repositories/service_repository.dart';
import '../usecase.dart';

class GetServiceDetailUsecase
    extends UseCase<Service, GetServiceDetailParams> {
  final ServiceRepository repository;

  GetServiceDetailUsecase({required this.repository});

  @override
  Future<Either<Failure, Service>> call(GetServiceDetailParams params) async {
    return await repository.getServiceWithSlots(params.serviceId);
  }
}

class GetServiceDetailParams extends Equatable {
  final String serviceId;

  const GetServiceDetailParams({required this.serviceId});

  @override
  List<Object?> get props => [serviceId];
}