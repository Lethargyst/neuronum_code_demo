import 'package:core/typedefs.dart';
import 'package:domain/entity/common/filter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'filter_dto.g.dart';

typedef ColumnDto = FilterDto;

/// DTO фильтра
@JsonSerializable()
class FilterDto {
  /// Айди фильтра
  @JsonKey(name: 'second')
  final String id;

  /// Имя фильтра
  @JsonKey(name: 'first')
  final String name;

  /// Выбранное значение фильтра
  final String? value;

  const FilterDto({
    required this.id,
    required this.name,
    this.value,
  });

  factory FilterDto.fromJson(Map<String, dynamic> json) => _$FilterDtoFromJson(json);

  static List<FilterDto> fromJsonList(List<dynamic> json) =>
    json.map((e) => FilterDto.fromJson(e as Map<String, dynamic>)).toList();

  Map<String, dynamic> toJson() => _$FilterDtoToJson(this);

  factory FilterDto.fromEntity(FilterEntity entity) => FilterDto(
    id: entity.id,
    name: entity.name ?? '',
    value: entity.value,
  );

  FilterEntity toEntity() => FilterEntity(
    id: id,
    name: name,
    value: value,
  );
}

extension Parser on List<FilterDto> {
  List<FilterEntity> toEntity() => map((e) => e.toEntity()).toList();
}

extension Serializable on List<FilterEntity> {
  Json toJson() => <String, String>{
    for (int i = 0; i < length; ++i)
      if (this[i].value != null) this[i].id: this[i].value!,
  };
}