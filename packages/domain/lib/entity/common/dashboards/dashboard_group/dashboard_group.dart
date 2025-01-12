import 'package:domain/entity/common/dashboards/dashboard_response/dashboard_response.dart';
import 'package:domain/entity/response/filter_options.dart';
import 'package:equatable/equatable.dart';

typedef DashboardGroupFilters = FilterOptions;

/// Entity группы дашбордов
class DashboardGroup extends Equatable {
  final String name;
  final List<DashboardResponse> dashboards;  
  final List<String>? options;

  const DashboardGroup({
    required this.name,
    required this.dashboards,
    this.options,
  });

  DashboardGroup copyWith({
    String? name,
    List<DashboardResponse>? dashboards,
    List<String>? options,
  }) => DashboardGroup(
    name: name ?? this.name,
    dashboards: dashboards ?? this.dashboards,
    options: options ?? this.options,
  );

  @override
  List<Object?> get props => [name, dashboards, options];
}
