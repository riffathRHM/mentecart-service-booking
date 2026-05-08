import 'package:dartz/dartz.dart';
import 'package:mentecart_mobile/core/errors/failures.dart';
import 'package:mentecart_mobile/domain/entities/auth/user.dart';
import 'package:mentecart_mobile/domain/repositories/auth_repository.dart';
import '../usecase.dart';

class GetCurrentUserUsecase extends UseCase<User, NoParams> {
  final AuthRepository repository;

  GetCurrentUserUsecase({required this.repository});

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await repository.getCurrentUser();
  }
}