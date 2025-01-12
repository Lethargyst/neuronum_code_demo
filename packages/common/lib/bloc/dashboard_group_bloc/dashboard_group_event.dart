part of 'dashboard_group_bloc.dart';

sealed class DashboardGroupEvent extends Equatable {
  const DashboardGroupEvent();
}

/// Ивент получения дашордов по группе
class GetDashboardGroupEvent extends DashboardGroupEvent {
  const GetDashboardGroupEvent();

  @override
  List<Object?> get props => [];
}

/// Ивент применения фильтров
class AcceptGroupFiltersEvent extends DashboardGroupEvent {
  final List<FilterEntity> filters;
  final TimeRange timeRange;

  const AcceptGroupFiltersEvent(this.filters, this.timeRange);

  @override
  List<Object?> get props => [filters, timeRange];
}