import 'package:domain/entity/time_range/time_range.dart';
import 'package:domain/utils/extensions/date_time_extension.dart';
import 'package:core/typedefs.dart';
import 'package:json_annotation/json_annotation.dart';

part 'time_interval_dto.g.dart';

/// DTO временного промежутка (даты, времени)
@JsonSerializable()
class TimeRangeDto {
  /// Начальная дата
  @JsonKey(name: 'oldestDate', fromJson: _dateFromJson, toJson: DateTimeX.dateToJson)
  final DateTime startDate;
  /// Конечная дата
  @JsonKey(name: 'newestDate', fromJson: _dateFromJson, toJson: DateTimeX.dateToJson)
  final DateTime endDate;
  /// Начальное время
  @JsonKey(name: 'oldestTime', fromJson: _timeFromJson, toJson: DateTimeX.timeToJson)
  final DateTime startTime;
  /// Конечное время
  @JsonKey(name: 'newestTime', fromJson: _timeFromJson, toJson: DateTimeX.timeToJson)
  final DateTime endTime;

  const TimeRangeDto({
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
  });

  factory TimeRangeDto.fromJson(Map<String, dynamic> json) => _$TimeRangeDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TimeRangeDtoToJson(this);

  factory TimeRangeDto.fromEntity(TimeRange entity) => TimeRangeDto(
    startDate: entity.startDate,
    endDate: entity.endDate,
    startTime:  entity.startTime,
    endTime: entity.endTime,
  );

  TimeRange toEntity() => TimeRange(
    startDate: startDate,
    endDate: endDate,
    startTime: startTime,
    endTime: endTime,
  );

  static DateTime _dateFromJson(String value) => DateTimeX.fromDateTimeStrings(value, '00:00:00');

  static DateTime _timeFromJson(String value) => DateTimeX.fromDateTimeStrings('01.01.2022', value);
}

extension Serializable on TimeRange {
  Json toJson() => TimeRangeDto.fromEntity(this).toJson();
}