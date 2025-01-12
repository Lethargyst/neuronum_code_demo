import 'package:domain/entity/common/dashboards/dashboard_column/dashboard_column.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_response.freezed.dart';

/// Entity дашборда
@freezed
class DashboardResponse with _$DashboardResponse {
  const factory DashboardResponse({
    required String nameX,
    required String nameY,
    required double maxY,
    required List<DashboardColumn> columns,
    String? groupName,
    String? name,
  }) = _DashboardResponse;
}
