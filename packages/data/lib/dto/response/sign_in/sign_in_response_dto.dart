import 'package:core/typedefs.dart';
import 'package:data/dto/common/auth/auth.dart';
import 'package:data/dto/common/user/user_dto.dart';
import 'package:domain/entity/response/sign_in_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sign_in_response_dto.g.dart';

/// DTO для данных ответа при логине
@JsonSerializable()
class SignInResponseDto {
  /// Пользователь
  @JsonKey()
  final UserDto user;

  /// Данные токена авторизации
  final AuthDataDto authData;

  SignInResponseDto({
    required this.user,
    required this.authData,
  });

  factory SignInResponseDto.fromJson(Map<String, dynamic> json) => 
    _$SignInResponseDtoFromJson(_jsonHandler(json));

  Map<String, dynamic> toJson() => _$SignInResponseDtoToJson(this);

  SignInResponse toEntity() => SignInResponse(
    user: user.toEntity(),
    authData: authData.toEntity(),
  );
}

Json _jsonHandler(Json json) => {
  'user' : {
    'id': json['id'],
    'name': json['name'],
    'surname': json['surname'],
    'email': json['email'],
    'telephonyProjects': json['telephonyProjects'],
  },
  'authData': {
    'token': json['token'],
    'refreshToken': json['refreshToken'],
    'expiresIn': json['expiresIn'],
    'refreshExpiresIn': json['refreshExpiresIn'],
  },
};
