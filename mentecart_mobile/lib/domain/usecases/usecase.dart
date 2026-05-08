import 'package:dartz/dartz.dart';
import 'package:mentecart_mobile/core/errors/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {
  const NoParams();
}