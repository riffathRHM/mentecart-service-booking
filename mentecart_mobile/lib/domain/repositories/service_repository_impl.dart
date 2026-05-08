import 'package:dartz/dartz.dart';
import 'package:mentecart_mobile/core/errors/failures.dart';
import 'package:mentecart_mobile/data/datasources/remote/service_remote_datasource.dart';
import 'package:mentecart_mobile/domain/entities/service/service.dart';
import 'package:mentecart_mobile/domain/repositories/service_repository.dart';

class ServiceRepositoryImpl implements ServiceRepository {
  final ServiceRemoteDataSource remoteDataSource;

  ServiceRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Service>>> getServices({
    int page = 1,
    int limit = 20,
    String? category,
    String? search,
  }) async {
    try {
      final result = await remoteDataSource.getServices(
        page: page,
        limit: limit,
        category: category,
        search: search,
      );

      return Right(result.map((model) => model.toDomain()).toList());
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Service>> getServiceById(String id) async {
    try {
      final result = await remoteDataSource.getServiceById(id);
      return Right(result.toDomain());
    } on Exception catch (e) {
      return Left(NotFoundFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Service>> getServiceWithSlots(String id) async {
    try {
      final result = await remoteDataSource.getServiceWithSlots(id);
      return Right(result.toDomain());
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}