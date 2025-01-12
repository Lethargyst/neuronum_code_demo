part of 'current_call_bloc.dart';

sealed class CurrentCallEvent extends Equatable {
  const CurrentCallEvent();
}

/// Выбрать звонок и отобразить подробную информацию
class PickCallEvent extends CurrentCallEvent {
  final Call? call;

  const PickCallEvent(this.call);

  @override
  List<Object?> get props => [call];
}

/// Закрыть подробную информацию о звонке
class ClearEvent extends CurrentCallEvent {
  const ClearEvent();

  @override
  List<Object?> get props => [];
}

/// Сохранить новый комменарий
class SaveCommentEvent extends CurrentCallEvent {
  final String comment;

  const SaveCommentEvent(this.comment);

  @override
  List<Object?> get props => [comment];
}