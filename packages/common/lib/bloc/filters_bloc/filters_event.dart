part of 'filters_bloc.dart';

sealed class FiltersEvent extends Equatable {
  const FiltersEvent();
  
  @override
  List<Object?> get props => [];
}

/// Событие получения фильтров c бэка
class GetFiltersEvent extends FiltersEvent {
  const GetFiltersEvent();
}

/// Событие получения фильтров из хранилища
class GetLocalFiltersEvent extends FiltersEvent {
  final List<String>? filtersIds;
  
  const GetLocalFiltersEvent([this.filtersIds]);

  @override
  List<Object?> get props => [filtersIds];
}

/// Событие выбора фильтра
class SetFilterEvent extends FiltersEvent {
  /// Айди фильтра
  final String id;

  /// Единичное значение фильтра
  final String? value;

  /// Значения фильтра списком
  final List<String>? valuesList;
  
  const SetFilterEvent(
    this.id, {
    this.value, 
    this.valuesList,
  });

  @override
  List<Object?> get props => [id, value];
}

/// Событие выбора времeнного промежутка
class SetRangeEvent extends FiltersEvent {
  /// Выбранная часть временного промежутка
  final TimeRangePart intervalPart;
  /// Значение даты/времени
  final DateTime value;
  
  const SetRangeEvent(this.intervalPart, this.value);

  @override
  List<Object?> get props => [intervalPart, value];
}

/// Событие подтверждения фильтров
class AcceptFiltersEvent extends FiltersEvent {
  const AcceptFiltersEvent();
}

/// Сбросить фильтры
class ResetFiltersEvent extends FiltersEvent {
  const ResetFiltersEvent();
}