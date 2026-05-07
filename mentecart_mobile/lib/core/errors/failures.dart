import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final String? errorCode;

  const Failure(this.message, {this.errorCode});

  @override
  List<Object?> get props => [message, errorCode];
}

class ValidationFailure extends Failure {
  const ValidationFailure(String message, {String? errorCode})
      : super(message, errorCode: errorCode ?? 'VALIDATION_ERROR');
}

class AuthenticationFailure extends Failure {
  const AuthenticationFailure(String message, {String? errorCode})
      : super(message, errorCode: errorCode ?? 'AUTH_FAILED');
}

class ServerFailure extends Failure {
  const ServerFailure(String message, {String? errorCode})
      : super(message, errorCode: errorCode ?? 'SERVER_ERROR');
}

class NetworkFailure extends Failure {
  const NetworkFailure(String message, {String? errorCode})
      : super(message, errorCode: errorCode ?? 'NETWORK_ERROR');
}

class CacheFailure extends Failure {
  const CacheFailure(String message, {String? errorCode})
      : super(message, errorCode: errorCode ?? 'CACHE_ERROR');
}

class ConflictFailure extends Failure {
  const ConflictFailure(String message, {String? errorCode})
      : super(message, errorCode: errorCode ?? 'CONFLICT');
}

class NotFoundFailure extends Failure {
  const NotFoundFailure(String message, {String? errorCode})
      : super(message, errorCode: errorCode ?? 'NOT_FOUND');
}