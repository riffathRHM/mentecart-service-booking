import 'package:json_annotation/json_annotation.dart';
import 'package:mentecart_mobile/domain/entities/auth/auth_response.dart';
import 'user_model.dart';

part 'auth_response_model.g.dart';

@JsonSerializable()
class AuthResponseModel {
  final UserModel user;
  @JsonKey(name: 'accessToken')
  final String accessToken;
  @JsonKey(name: 'refreshToken')
  final String? refreshToken;
  @JsonKey(name: 'expiresIn')
  final String expiresIn;

  AuthResponseModel({
    required this.user,
    required this.accessToken,
    this.refreshToken,
    required this.expiresIn,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseModelToJson(this);

  AuthResponse toDomain() => AuthResponse(
    user: user.toDomain(),
    accessToken: accessToken,
    refreshToken: refreshToken,
    expiresIn: expiresIn,
  );
}