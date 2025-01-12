import 'package:data/dto/response/tag/tag_dto.dart';
import 'package:domain/utils/extensions/date_time_extension.dart';
import 'package:data/dto/common/call_data/call_data_dto.dart';
import 'package:domain/entity/common/call/call.dart';
import 'package:json_annotation/json_annotation.dart';

part 'call_dto.g.dart';

/// DTO звонка
@JsonSerializable()
class CallDto {
  /// Дополнительные параметры звонка
  @JsonKey(includeToJson: false)
  final CallDataDto callData;

  /// Айди звонка
  final String id;

  /// Айди проекта
  final String projectId;

  /// Текст звонка
  final String text;

  /// Дата и время звонка
  final DateTime dateTime;

  /// Теги звонка
  @JsonKey(defaultValue: [])
  final List<TagDto> tags;

  /// Текст анализа отказа в записи
  @JsonKey(name: 'whyNo')
  final String? refuseAnalytics;

  /// Текст анализа звонка
  @JsonKey(name: 'analysis')
  final String? callAnalytics;

  /// Текст анализа работы администратора
  @JsonKey(name: 'adminQuality')
  final String? adminAnalytics;
  
  const CallDto({
    required this.callData,
    required this.id,
    required this.projectId,
    required this.text,
    required this.dateTime,
    required this.tags,
    this.refuseAnalytics,
    this.callAnalytics,
    this.adminAnalytics,
  });

  factory CallDto.fromJson(Map<String, dynamic> json) => _$CallDtoFromJson({
    ...json,
    'dateTime': DateTimeX.fromDateTimeStrings(
      json['date'] as String, 
      json['time'] as String,
    ).toIso8601String(),
    'callData': json,
  });

  static List<CallDto> fromJsonList(List<dynamic> json) =>
    json.map((e) => CallDto.fromJson(e as Map<String, dynamic>)).toList();

  Map<String, dynamic> toJson() => {
    ..._$CallDtoToJson(this),
    'date': dateTime.formattedDateString,
    'time': dateTime.formattedTimeString,
    ...callData.toJson(),
  };

  factory CallDto.fromEntity(Call entity) => CallDto(
    callData: CallDataDto.fromEntity(entity.callData),
    tags: entity.tags
      .map(TagDto.fromEntity)
      .toList(),
    id: entity.id,
    projectId: entity.projectId,
    text: entity.text,
    dateTime: entity.dateTime,
    refuseAnalytics: entity.refuseAnalytics,
    callAnalytics: entity.callAnalytics,
    adminAnalytics: entity.adminAnalytics,
  );

  Call toEntity() => Call(
    callData: callData.toEntity(),
    id: id,
    projectId: projectId,
    text: text,
    dateTime: dateTime,
    tags: tags.toEntity(),
    refuseAnalytics: refuseAnalytics,
    callAnalytics: callAnalytics,
    adminAnalytics: adminAnalytics,
  );
}

extension Parser on List<CallDto> {
  List<Call> toEntity() => map((e) => e.toEntity()).toList();
}