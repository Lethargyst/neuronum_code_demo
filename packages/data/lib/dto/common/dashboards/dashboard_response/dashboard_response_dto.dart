import 'package:data/dto/common/dashboards/dashboard_column/dashboard_column_dto.dart';
import 'package:domain/entity/common/dashboards/dashboard_response/dashboard_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dashboard_response_dto.g.dart';

/// DTO дашборда
@JsonSerializable()
class DashboardResponseDto {
  @JsonKey(name: 'x')
  final String nameX;
  @JsonKey(name: 'y')
  final String nameY;
  final double maxY;
  final List<DashboardColumnDto> columns;
  final String? name;

  const DashboardResponseDto({
    required this.nameX,
    required this.nameY,
    required this.maxY,
    required this.columns,
    this.name,
  });

  factory DashboardResponseDto.fromJson(Map<String, dynamic> json) => _$DashboardResponseDtoFromJson(json);

  static List<DashboardResponseDto> fromJsonList(List<dynamic> json) =>
    json.map((e) => DashboardResponseDto.fromJson(e as Map<String, dynamic>)).toList();

  DashboardResponse toEntity() => DashboardResponse(
    nameX: nameX,
    nameY: nameY,
    maxY: maxY,
    columns: columns.toEntity(),
    name: name,
  );
}

extension Parser on List<DashboardResponseDto> {
  List<DashboardResponse> toEntity() => map((e) => e.toEntity()).toList();
}