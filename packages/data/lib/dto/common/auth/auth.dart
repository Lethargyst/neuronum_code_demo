import 'package:domain/entity/common/auth.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth.g.dart';

/// DTO данных авторизации
@JsonSerializable()
class AuthDataDto {
  /// Токен доступа
  final String token;

  /// Токен обновления
  final String refreshToken;

  /// Когда истекает токен доступа
  final int expiresIn;
  
  /// Когда истекает токен обновления
  final int refreshExpiresIn;

  const AuthDataDto({
    required this.token,
    required this.refreshToken,
    required this.expiresIn,
    required this.refreshExpiresIn,
  });

  factory AuthDataDto.fromJson(Map<String, dynamic> json) => _$AuthDataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AuthDataDtoToJson(this);

  AuthData toEntity() => AuthData(
    token: token,
    refreshToken: refreshToken,
    expiresAt: DateTime.now().add(Duration(seconds: expiresIn)).toLocal(),
    refreshExpiresAt: DateTime.now().add(Duration(seconds: refreshExpiresIn)).toLocal(),
  );
}
