import 'package:domain/entity/comment/comment.dart';
import 'package:json_annotation/json_annotation.dart';

part 'comment_dto.g.dart';

/// DTO комментария к звонку
@JsonSerializable()
class CommentDto {
  final String userId;
  final String userName;
  final String value;

  const CommentDto({
    required this.userId,
    required this.userName,
    required this.value,
  });

  factory CommentDto.fromJson(Map<String, dynamic> json) => _$CommentDtoFromJson(json);

  static List<CommentDto> fromJsonList(List<dynamic> json) =>
    json.map((e) => CommentDto.fromJson(e as Map<String, dynamic>)).toList();

  Map<String, dynamic> toJson() => _$CommentDtoToJson(this);

  factory CommentDto.fromEntity(CommentEntity entity) => CommentDto(
    userId: entity.userId,
    userName: entity.userName,
    value: entity.value,
  );

  CommentEntity toEntity() => CommentEntity(
    userId: userId,
    userName: userName,
    value: value,
  );
}

extension Parser on List<CommentDto> {
  List<CommentEntity> toEntity() => map((e) => e.toEntity()).toList();
}