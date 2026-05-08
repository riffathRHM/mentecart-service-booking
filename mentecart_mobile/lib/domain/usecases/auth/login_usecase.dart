import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mentecart_mobile/core/errors/failures.dart';
import 'package:mentecart_mobile/domain/entities/auth/auth_response.dart';
import 'package:mentecart_mobile/domain/repositories/auth_repository.dart';
import '../usecase.dart';

class LoginUsecase extends UseCase<AuthResponse, LoginParams> {
  final AuthRepository repository;

  LoginUsecase({required this.repository});

  @override
  Future<Either<Failure, AuthResponse>> call(LoginParams params) async {
    return await repository.login(
      email: params.email,
      password: params.password,
    );
  }
}

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}