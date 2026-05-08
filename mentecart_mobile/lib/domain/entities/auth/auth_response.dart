import 'package:equatable/equatable.dart';
import 'user.dart';

class AuthResponse extends Equatable {
  final User user;
  final String accessToken;
  final String? refreshToken;
  final String expiresIn;

  const AuthResponse({
    required this.user,
    required this.accessToken,
    this.refreshToken,
    required this.expiresIn,
  });

  @override
  List<Object?> get props => [user, accessToken, refreshToken, expiresIn];
}