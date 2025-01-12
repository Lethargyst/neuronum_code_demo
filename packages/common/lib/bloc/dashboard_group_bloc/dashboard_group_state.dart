part of 'dashboard_group_bloc.dart';

sealed class DashboardGroupState extends Equatable {
  const DashboardGroupState();
}

class SuccessState extends DashboardGroupState {
  final List<FilterEntity> filters;
  final DashboardGroup? dashboardGroup;

  const SuccessState({required this.filters, this.dashboardGroup});

  SuccessState copyWith({
    List<FilterEntity>? filters,
    DashboardGroup? dashboardGroup,
  })
    => SuccessState(
      filters: filters ?? this.filters,
      dashboardGroup: dashboardGroup ?? this.dashboardGroup,
    );

  @override
  List<Object> get props => [filters];
}

class FailureState extends DashboardGroupState {
  final String message;

  const FailureState(this.message);
  
  @override
  List<Object> get props => [message];
}

class LoadingState extends DashboardGroupState {
  const LoadingState();
  
  @override
  List<Object> get props => [];
}
