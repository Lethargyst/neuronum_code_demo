part of 'additional_table_bloc.dart';

sealed class AdditionalTableEvent extends Equatable {
  const AdditionalTableEvent();

  @override
  List<Object?> get props => [];
}

/// Событие получения колонок таблицы
class InitialFetchEvent extends AdditionalTableEvent {
  const InitialFetchEvent();
}