import 'package:domain/core/constants.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_filters.freezed.dart';

/// Entity фильтров дашборда
@freezed
class DashboardFilters with _$DashboardFilters {
  const factory DashboardFilters({
    required DateTime startDate,
    required DateTime endDate,
    required String group,
    List<String>? filters,
  }) = _DashboardFilters;

  factory DashboardFilters.empty() => DashboardFilters(
    startDate: globalStartDate, 
    endDate: DateTime.now(), 
    group: '',
  );
}
