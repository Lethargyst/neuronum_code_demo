part of 'dashboards_bloc.dart';

sealed class DashboardsEvent extends Equatable {
  const DashboardsEvent();
}

/// Ивент получения групп дашбордов
class GetDashboardsEvent extends DashboardsEvent {
  @override
  List<Object?> get props => [];
}