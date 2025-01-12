part of 'filters_bloc.dart';

sealed class FiltersState extends Equatable {
  const FiltersState();
}

/// Стейт успеха
class FiltersSuccessState extends FiltersState {
  final List<FilterEntity> filters;
  final TimeRange interval;

  const FiltersSuccessState({required this.filters, required this.interval});

  bool get exportIsPossible => interval.inDays > 60;

  FiltersSuccessState copyWith({
    List<FilterEntity>? filters,
    TimeRange? interval,
  }) 
    => FiltersSuccessState(
      filters: filters ?? this.filters, 
      interval: interval ?? this.interval,
    );

  @override
  List<Object> get props => [
    filters,
    filters.hashCode,
    interval,
  ];
}

/// Стейт ошибки
class FiltersFailureState extends FiltersState {
  final String message;

  const FiltersFailureState(this.message);
  
  @override
  List<Object> get props => [message];
}

/// Стейт загрузки
class FiltersLoadingState extends FiltersState {
  const FiltersLoadingState();
  
  @override
  List<Object> get props => [];
}

/// Стейт подтверждения фильтров
class FiltersAcceptedState extends FiltersState {
  final List<FilterEntity> filters;
  final TimeRange interval;

  const FiltersAcceptedState({required this.filters, required this.interval});
  
  @override
  List<Object> get props => [];
}
