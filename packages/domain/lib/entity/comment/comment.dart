import 'package:equatable/equatable.dart';

/// Entity комментария
class CommentEntity extends Equatable {
  final String userId;
  final String userName;
  final String value;

  const CommentEntity({
    required this.userId,
    required this.userName,
    required this.value,
  });

  CommentEntity copyWith({
    String? userId,
    String? userName,
    String? value,
  }) => CommentEntity(
    userId: userId ?? this.userId,
    userName: userName ?? this.userName,
    value: value ?? this.value,
  );

  @override
  List<Object?> get props => [userId, userName, value];
}

extension CommentsListHelper on List<CommentEntity>? {
  bool get isEmpty => 
    this == null || 
    this!.isEmpty &&
    this!.every((e) => e.value.isEmpty);
}