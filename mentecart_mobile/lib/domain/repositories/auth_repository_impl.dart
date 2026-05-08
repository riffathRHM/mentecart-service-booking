import 'package:dartz/dartz.dart';
import 'package:mentecart_mobile/core/errors/failures.dart';
import 'package:mentecart_mobile/data/datasources/local/auth_local_datasource.dart';
import 'package:mentecart_mobile/data/datasources/remote/auth_remote_datasource.dart';
import 'package:mentecart_mobile/domain/entities/auth/auth_response.dart';
import 'package:mentecart_mobile/domain/entities/auth/user.dart';
import 'package:mentecart_mobile/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, AuthResponse>> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final result = await remoteDataSource.signup(
        name: name,
        email: email,
        password: password,
      );

      // Save token
      await localDataSource.saveToken(result.accessToken);

      return Right(result.toDomain());
    } on Exception catch (e) {
      return Left(AuthenticationFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthResponse>> login({
    required String email,
    required String password,
  }) async {
    try {
      final result = await remoteDataSource.login(
        email: email,
        password: password,
      );

      // Save token
      await localDataSource.saveToken(result.accessToken);

      return Right(result.toDomain());
    } on Exception catch (e) {
      return Left(AuthenticationFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final result = await remoteDataSource.getCurrentUser();
      return Right(result.toDomain());
    } on Exception catch (e) {
      return Left(AuthenticationFailure(e.toString()));
    }
  }

  @override
  Future<void> logout() async {
    await localDataSource.deleteToken();
  }

  @override
  Future<void> saveToken(String token) async {
    await localDataSource.saveToken(token);
  }

  @override
  Future<String?> getToken() async {
    return await localDataSource.getToken();
  }
}