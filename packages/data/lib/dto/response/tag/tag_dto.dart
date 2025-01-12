import 'package:domain/entity/response/tag.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tag_dto.g.dart';

/// DTO тега звонка
@JsonSerializable()
class TagDto {
  final String value;
  final int color;
  @JsonKey(name: 'icon', fromJson: TagType.fromCode)
  final TagType? tagType;

  const TagDto({
    required this.value,
    required this.color,
    this.tagType,
  });

  factory TagDto.fromJson(Map<String, dynamic> json) => _$TagDtoFromJson(json);

  static List<TagDto> fromJsonList(List<dynamic> json) =>
    json.map((e) => TagDto.fromJson(e as Map<String, dynamic>)).toList();

  Map<String, dynamic> toJson() => _$TagDtoToJson(this);

  factory TagDto.fromEntity(TagEntity entity) => TagDto(
    value: entity.value,
    color: entity.color,
    tagType: entity.tagType,
  );

  TagEntity toEntity() => TagEntity(
    value: value,
    color: color,
    tagType: tagType,
  );
}

extension Parser on List<TagDto> {
  List<TagEntity> toEntity() => map((e) => e.toEntity()).toList();
}