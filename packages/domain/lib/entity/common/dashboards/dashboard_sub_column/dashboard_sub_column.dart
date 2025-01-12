import 'package:equatable/equatable.dart';

/// Entity вертикальной оси дашборда
class DashboardSubColumn extends Equatable {
  final double valueY;
  final String? name;

  const DashboardSubColumn({
    required this.valueY,
    required this.name,
  });

  @override
  List<Object?> get props => [valueY, name];
}
