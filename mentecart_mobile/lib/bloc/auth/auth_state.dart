import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final String userId;
  final String name;
  final String email;

  const AuthAuthenticated({
    required this.userId,
    required this.name,
    required this.email,
  });

  @override
  List<Object?> get props => [userId, name, email];
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthError extends AuthState {
  final String message;
  final String? errorCode;

  const AuthError(this.message, {this.errorCode});

  @override
  List<Object?> get props => [message, errorCode];
}