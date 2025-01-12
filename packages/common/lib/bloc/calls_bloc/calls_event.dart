part of 'calls_bloc.dart';

sealed class CallsEvent extends Equatable {
  const CallsEvent();
}

/// Событие получения звонков
class GetCallsEvent extends CallsEvent {
  final bool withInitialFilters;

  const GetCallsEvent({this.withInitialFilters = false});

  @override
  List<Object?> get props => [withInitialFilters];
}

/// Событие обновления одного звонка
class UpdateCallEvent extends CallsEvent {
  final Call call;

  const UpdateCallEvent(this.call);
  
  @override
  List<Object?> get props => [call];
}

/// Событие подтверждения фильтров
class SetFiltersEvent extends CallsEvent {
  final List<FilterEntity> filters;
  final TimeRange interval;
  
  const SetFiltersEvent({required this.filters, required this.interval});

  @override
  List<Object?> get props => [filters, interval];
}

/// Событие пагинации
class PaginationEvent extends CallsEvent {
  const PaginationEvent();

  @override
  List<Object?> get props => [];
}