part of 'comment_bloc.dart';

/// Статус комментария
enum CommentStatus {
  success,
  loading,
  failure
}

sealed class CommentState extends Equatable {
  final String comment;
  final CommentStatus status;

  const CommentState({
    required this.comment, 
    required this.status,
  });

  CommentState copyWith({
    String? comment,
    CommentStatus? status,
  });
}

/// Стейт успеха
class CommonState extends CommentState {
  const CommonState({
    required super.comment, 
    super.status = CommentStatus.success,
  });

  @override
  CommonState copyWith({
    String? comment,
    CommentStatus? status,
  }) 
    => CommonState(
      comment: comment ?? this.comment, 
      status: status ?? this.status,
    );


  @override
  List<Object> get props => [comment, status];
}

/// Стейт редактирования комментария
class EditingState extends CommentState {
  const EditingState({
    required super.comment, 
    required super.status,
  });
  
  @override
  EditingState copyWith({
    String? comment,
    CommentStatus? status,
  }) 
    => EditingState(
      comment: comment ?? this.comment, 
      status: status ?? this.status,
    );

  @override
  List<Object> get props => [comment, status];
}