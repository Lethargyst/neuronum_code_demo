import 'package:domain/core/constants.dart';
import 'package:domain/utils/extensions/date_time_extension.dart';
import 'package:equatable/equatable.dart';

enum TimeRangePart {
  startDate,
  endDate,
  startTime,
  endTime
}

/// Entity временного промежутка (даты, времени)
class TimeRange extends Equatable {
  /// Начальная дата
  final DateTime startDate;
  /// Конечная дата
  final DateTime endDate;
  /// Начальное время
  final DateTime startTime;
  /// Конечное время
  final DateTime endTime;

  const TimeRange({
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
  });

  factory TimeRange.common() => TimeRange(
    startDate: globalStartDate, 
    endDate: DateTime.now(), 
    startTime: DateTimeX.time(7, 0), 
    endTime: DateTimeX.time(22, 00),
  );

  TimeRange copyWith({
    DateTime? startDate,
    DateTime? endDate,
    DateTime? startTime,
    DateTime? endTime,
  }) => TimeRange(
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    startTime: startTime ?? this.startTime,
    endTime: endTime ?? this.endTime,
  );

  int get inDays => endDate.difference(startDate).inDays; 

  @override
  List<Object?> get props => [
    startDate,
    endDate,
    startTime,
    endTime,
  ];
}
