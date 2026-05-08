import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mentecart_mobile/core/errors/failures.dart';
import 'package:mentecart_mobile/domain/entities/auth/auth_response.dart';
import 'package:mentecart_mobile/domain/repositories/auth_repository.dart';
import '../usecase.dart';

class SignupUsecase extends UseCase<AuthResponse, SignupParams> {
  final AuthRepository repository;

  SignupUsecase({required this.repository});

  @override
  Future<Either<Failure, AuthResponse>> call(SignupParams params) async {
    return await repository.signup(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}

class SignupParams extends Equatable {
  final String name;
  final String email;
  final String password;

  const SignupParams({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [name, email, password];
}