part of 'export_bloc.dart';

sealed class ExportEvent extends Equatable {
  const ExportEvent();
}

final class LoadEvent extends ExportEvent {
  const LoadEvent();

  @override
  List<Object?> get props => [];
}

final class UpdateFiltersEvent extends ExportEvent {
  final List<FilterEntity> filters;
  final TimeRange timeRange;
  
  const UpdateFiltersEvent({
    required this.filters,
    required this.timeRange,
  });

  @override
  List<Object?> get props => [filters, timeRange];
}
