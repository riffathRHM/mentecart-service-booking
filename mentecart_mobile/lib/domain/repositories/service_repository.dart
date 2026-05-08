import 'package:dartz/dartz.dart';
import 'package:mentecart_mobile/core/errors/failures.dart';
import 'package:mentecart_mobile/domain/entities/service/service.dart';

abstract class ServiceRepository {
  Future<Either<Failure, List<Service>>> getServices({
    int page = 1,
    int limit = 20,
    String? category,
    String? search,
  });

  Future<Either<Failure, Service>> getServiceById(String id);

  Future<Either<Failure, Service>> getServiceWithSlots(String id);
}