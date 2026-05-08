import 'package:dartz/dartz.dart';
import 'package:mentecart_mobile/core/errors/failures.dart';
import 'package:mentecart_mobile/domain/entities/auth/auth_response.dart';
import 'package:mentecart_mobile/domain/entities/auth/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthResponse>> signup({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, AuthResponse>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> getCurrentUser();

  Future<void> logout();

  Future<void> saveToken(String token);

  Future<String?> getToken();
}