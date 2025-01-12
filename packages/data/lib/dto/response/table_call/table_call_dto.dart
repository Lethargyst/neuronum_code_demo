import 'package:data/dto/response/prop/prop_dto.dart';
import 'package:domain/entity/response/table_call.dart';
import 'package:domain/utils/extensions/date_time_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'table_call_dto.g.dart';

/// DTO звонка из таблицы
@JsonSerializable(createToJson: false)
class TableCallDto {
  /// Айди звонка
  final String id;
  /// Номер телефона клиента
  final String phoneNumber;
  /// Дата и время звонка
  final DateTime dateTime;
  /// Входящий ли звонок
  final bool isIncoming;
  /// Характеристики звонка
  @JsonKey(name: 'data')
  final List<PropDto> properties;

  const TableCallDto({
    required this.id,
    required this.phoneNumber,
    required this.dateTime,
    required this.isIncoming,
    required this.properties,
  });

  factory TableCallDto.fromJson(Map<String, dynamic> json) => _$TableCallDtoFromJson({
    ...json,
    'dateTime': DateTimeX.fromDateTimeStrings(
      json['date'] as String, 
      json['time'] as String,
    ).toIso8601String(),
  });

  static List<TableCallDto> fromJsonList(List<dynamic> json) =>
    json.map((e) => TableCallDto.fromJson(e as Map<String, dynamic>)).toList();

  TableCall toEntity() => TableCall(
    id: id,
    phoneNumber: phoneNumber,
    dateTime: dateTime,
    isIncoming: isIncoming,
    properties: properties.toEntity(),
  );
}

extension Parser on List<TableCallDto> {
  List<TableCall> toEntity() => map((e) => e.toEntity()).toList();
}