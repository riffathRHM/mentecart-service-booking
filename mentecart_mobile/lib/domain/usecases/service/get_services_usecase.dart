import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mentecart_mobile/core/errors/failures.dart';
import 'package:mentecart_mobile/domain/entities/service/service.dart';
import 'package:mentecart_mobile/domain/repositories/service_repository.dart';
import '../usecase.dart';

class GetServicesUsecase extends UseCase<List<Service>, GetServicesParams> {
  final ServiceRepository repository;

  GetServicesUsecase({required this.repository});

  @override
  Future<Either<Failure, List<Service>>> call(GetServicesParams params) async {
    return await repository.getServices(
      page: params.page,
      limit: params.limit,
      category: params.category,
      search: params.search,
    );
  }
}

class GetServicesParams extends Equatable {
  final int page;
  final int limit;
  final String? category;
  final String? search;

  const GetServicesParams({
    this.page = 1,
    this.limit = 20,
    this.category,
    this.search,
  });

  @override
  List<Object?> get props => [page, limit, category, search];
}