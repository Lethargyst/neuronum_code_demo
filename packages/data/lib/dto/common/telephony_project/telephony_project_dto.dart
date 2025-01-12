import 'package:domain/entity/common/telephony_project.dart';
import 'package:json_annotation/json_annotation.dart';

part 'telephony_project_dto.g.dart';

/// DTO телефонии
@JsonSerializable()
class TelephonyProjectDto {
  /// ID телефонии
  final String id;

  /// Список ID таблиц
  @JsonKey(name: 'additionalCallsTables')
  final List<String> callsTablesIds;


  const TelephonyProjectDto({
    required this.id,
    required this.callsTablesIds,
  });

  factory TelephonyProjectDto.fromJson(Map<String, dynamic> json) => _$TelephonyProjectDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TelephonyProjectDtoToJson(this);

  factory TelephonyProjectDto.fromEntity(TelephonyProject entity) => TelephonyProjectDto(
    id: entity.id, 
    callsTablesIds: entity.callsTablesIds,
  );

  TelephonyProject toEntity() => TelephonyProject(
    id: id,
    callsTablesIds: callsTablesIds,
  );
}
