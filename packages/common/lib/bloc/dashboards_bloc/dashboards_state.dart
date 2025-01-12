part of 'dashboards_bloc.dart';

sealed class DashboardsState extends Equatable {
  const DashboardsState();
}

class SuccessState extends DashboardsState {
  final List<DashboardGroupFilters> options;

  const SuccessState({required this.options});

  @override
  List<Object> get props => [options];
}

class FailureState extends DashboardsState {
  final String message;

  const FailureState(this.message);
  
  @override
  List<Object> get props => [message];
}

class LoadingState extends DashboardsState {
  const LoadingState();
  
  @override
  List<Object> get props => [];
}
