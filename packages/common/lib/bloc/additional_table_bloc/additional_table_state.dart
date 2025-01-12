part of 'additional_table_bloc.dart';

sealed class AdditionalTableState extends Equatable {
  const AdditionalTableState();
}

/// Стейт успеха
class SuccessState extends AdditionalTableState {
  final List<TableCall> firstPageItems;
  final List<Section> columns;

  const SuccessState({
    required this.firstPageItems, 
    required this.columns,
  });

  @override
  List<Object> get props => [
    firstPageItems,
    firstPageItems.hashCode,
  ];
}

/// Стейт ошибки
class FailureState extends AdditionalTableState {
  final String message;

  const FailureState(this.message);
  
  @override
  List<Object> get props => [message];
}

/// Стейт загрузки
class LoadingState extends AdditionalTableState {
  const LoadingState();
  
  @override
  List<Object> get props => [];
}