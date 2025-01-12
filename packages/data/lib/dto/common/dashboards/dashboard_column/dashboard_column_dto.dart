import 'package:data/dto/common/dashboards/dashboard_sub_column/dashboard_sub_column_dto.dart';
import 'package:domain/entity/common/dashboards/dashboard_column/dashboard_column.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dashboard_column_dto.g.dart';

/// DTO горизонтальной оси дашборда
@JsonSerializable()
class DashboardColumnDto {
  final String valueX;
  final List<DashboardSubColumnDto> subColumns;

  const DashboardColumnDto({
    required this.valueX,
    required this.subColumns,
  });

  factory DashboardColumnDto.fromJson(Map<String, dynamic> json) => _$DashboardColumnDtoFromJson(json);

  static List<DashboardColumnDto> fromJsonList(List<dynamic> json) =>
    json.map((e) => DashboardColumnDto.fromJson(e as Map<String, dynamic>)).toList();

  DashboardColumn toEntity() => DashboardColumn(
    valueX: valueX,
    subColumns: subColumns.toEntity(),
  );
}

extension Parser on List<DashboardColumnDto> {
  List<DashboardColumn> toEntity() => map((e) => e.toEntity()).toList();
}