import 'package:domain/entity/common/dashboards/dashboard_sub_column/dashboard_sub_column.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dashboard_sub_column_dto.g.dart';

/// DTO вертикальной оси дашборда
@JsonSerializable()
class DashboardSubColumnDto {
  final double valueY;
  final String? name;

  const DashboardSubColumnDto({
    required this.valueY,
    required this.name,
  });

  factory DashboardSubColumnDto.fromJson(Map<String, dynamic> json) => _$DashboardSubColumnDtoFromJson(json);

  static List<DashboardSubColumnDto> fromJsonList(List<dynamic> json) =>
    json.map((e) => DashboardSubColumnDto.fromJson(e as Map<String, dynamic>)).toList();


  DashboardSubColumn toEntity() => DashboardSubColumn(
    valueY: valueY,
    name: name,
  );
}

extension Parser on List<DashboardSubColumnDto> {
  List<DashboardSubColumn> toEntity() => map((e) => e.toEntity()).toList();
}