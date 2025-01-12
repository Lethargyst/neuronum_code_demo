import 'package:domain/entity/common/dashboards/dashboard_filters/dashboard_filters.dart';
import 'package:domain/utils/extensions/date_time_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dashboard_filters_dto.g.dart';

/// DTO фильтров дашборда
@JsonSerializable()
class DashboardFiltersDto {
  @JsonKey(name: 'oldestDate', toJson: DateTimeX.dateToJson)
  final DateTime startDate;
  @JsonKey(name: 'newestDate', toJson: DateTimeX.dateToJson)
  final DateTime endDate;
  final String group;
  @JsonKey(name: 'dashboardsToShowWith')
  final List<String>? filters;

  const DashboardFiltersDto({
    required this.startDate,
    required this.endDate,
    required this.group,
    this.filters,
  });

  Map<String, dynamic> toJson() => _$DashboardFiltersDtoToJson(this);

  factory DashboardFiltersDto.fromEntity(DashboardFilters entity) => DashboardFiltersDto(
    startDate: entity.startDate,
    endDate: entity.endDate,
    group: entity.group,
    filters: entity.filters,
  );
}