import 'dart:convert';

import 'package:data/dto/common/telephony_project/telephony_project_dto.dart';
import 'package:domain/entity/common/user.dart';
import 'package:domain/service/cache/cache_client.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_dto.g.dart';

/// DTO пользователя
@JsonSerializable()
class UserDto extends CacheObject {
  /// ID пользователя
  final String id;

  /// Имя
  final String name;

  /// Фамилия
  final String surname;

  /// Почта
  final String email;

  /// Список телефоний
  @JsonKey(name: 'telephonyProjects')
  final List<TelephonyProjectDto> projects;

  UserDto({
    required this.id,
    required this.name,
    required this.surname,
    required this.email,
    required this.projects,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) => _$UserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserDtoToJson(this);

  factory UserDto.fromEntity(User entity) => UserDto(
    id: entity.id, 
    name: entity.name!, 
    surname: entity.surname!, 
    email: entity.email!, 
    projects: entity.projects.map(TelephonyProjectDto.fromEntity).toList(),
  );

  User toEntity() => User(
    id: id,
    name: name,
    surname: surname,
    email: email,
    projects: projects.map((e) => e.toEntity()).toList(),
  );

  @override
  String toJsonString() => jsonEncode(toJson());
}
