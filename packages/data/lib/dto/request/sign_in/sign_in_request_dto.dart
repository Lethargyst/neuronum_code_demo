import 'package:domain/entity/request/sign_in_request.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sign_in_request_dto.g.dart';

/// DTO для данных логина
@JsonSerializable()
class SignInRequestDto {
  /// Логин
  @JsonKey(name: 'email')
  final String login;

  /// Имя
  final String password;

  SignInRequestDto({
    required this.login,
    required this.password,
  });

  factory SignInRequestDto.fromJson(Map<String, dynamic> json) => _$SignInRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SignInRequestDtoToJson(this);

  factory SignInRequestDto.fromEntity(SignInRequest entity) => SignInRequestDto(
    login: entity.login, 
    password: entity.password, 
  );

  SignInRequest toEntity() => SignInRequest(
    login: login,
    password: password,
  );
}
