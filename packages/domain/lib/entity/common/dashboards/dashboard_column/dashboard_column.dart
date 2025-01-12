import 'package:domain/entity/common/dashboards/dashboard_sub_column/dashboard_sub_column.dart';
import 'package:equatable/equatable.dart';

/// Entity горизонтальной оси дашборда
class DashboardColumn extends Equatable {
  final String valueX;
  final List<DashboardSubColumn> subColumns;

  const DashboardColumn({
    required this.valueX,
    required this.subColumns,
  });

  @override
  List<Object?> get props => [valueX, subColumns];
}
