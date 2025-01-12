part of 'comment_bloc.dart';

sealed class CommentEvent extends Equatable {
  const CommentEvent();
}

/// Начать редактирования комментария
class StartEditingEvent extends CommentEvent {
  const StartEditingEvent();

  @override
  List<Object?> get props => [];
}

/// Завершить редактирования комментария
class StopEditingEvent extends CommentEvent {
  const StopEditingEvent();

  @override
  List<Object?> get props => [];
}

/// Изменить значение комментария
class EditCommentEvent extends CommentEvent {
  final String comment;

  const EditCommentEvent(this.comment);

  @override
  List<Object?> get props => [comment];
}

/// Удалить комментарий
class DeleteCommentEvent extends CommentEvent {
  const DeleteCommentEvent();

  @override
  List<Object?> get props => [];
}

/// Сохранить комментарий 
class SaveEvent extends CommentEvent {
  const SaveEvent();

  @override
  List<Object?> get props => [];
}
