import 'package:data/dto/comment/comment_dto.dart';
import 'package:domain/entity/common/call/call.dart';
import 'package:json_annotation/json_annotation.dart';

part 'call_data_dto.g.dart';

typedef CallDataField = _$CallDataDtoJsonKeys;

/// DTO параметров звонка
@JsonSerializable(
  createJsonKeys: true,
  createFieldMap: true,
)
final class CallDataDto {
  /// Номер телефона клиента
  final String? phoneNumber;

  /// Услуга
  @JsonKey(name: 'doctor')
  final String? service;

  /// Имя клиента
  final String? clientName;

  /// Имя администратора
  @JsonKey(name: 'administratorName')
  final String? adminName;

  /// Виртуальный номер клиента
  final String? virtualNumber;

  /// Статус записи клиента
  @JsonKey(name: 'record')
  final String? recordStatus;
  
  /// Обращался ли клиент до этого
  @JsonKey(name: 'wasBefore')
  final String? visitedBefore;

  /// Комментарии к звонку
  final List<CommentDto>? comments;

  /// Входящий ли звонок
  final bool? isIncoming;

  const CallDataDto({
    this.phoneNumber,
    this.service,
    this.clientName,
    this.adminName,
    this.virtualNumber,
    this.recordStatus,
    this.isIncoming,
    this.comments,
    this.visitedBefore,
  });

  factory CallDataDto.fromJson(Map<String, dynamic> json) => _$CallDataDtoFromJson(json);

  static List<CallDataDto> fromJsonList(List<dynamic> json) =>
    json.map((e) => CallDataDto.fromJson(e as Map<String, dynamic>)).toList();

  Map<String, dynamic> toJson() => _$CallDataDtoToJson(this);

  factory CallDataDto.fromEntity(CallData entity) => CallDataDto(
    phoneNumber: entity.phoneNumber,
    service: entity.service,
    clientName: entity.clientName,
    adminName: entity.adminName,
    virtualNumber: entity.virtualNumber,
    recordStatus: entity.recordStatus,
    isIncoming: entity.isIncoming,
    comments: entity.comments
      ?.map(CommentDto.fromEntity)
      .toList(),
    visitedBefore: entity.visitedBefore,
  );

  CallData toEntity() => CallData(
    phoneNumber: phoneNumber,
    service: service,
    clientName: clientName,
    adminName: adminName,
    virtualNumber: virtualNumber,
    recordStatus: recordStatus,
    isIncoming: isIncoming,
    comments: comments?.toEntity(),
    visitedBefore: visitedBefore,
  );

  List<String> get fields => _$CallDataDtoFieldMap.keys.toList();
  List<String> get fieldsBackend => _$CallDataDtoFieldMap.values.toList();
}