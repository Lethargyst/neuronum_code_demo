import 'package:equatable/equatable.dart';

enum TagType {
  info,
  warning,
  good,
  time;

  static TagType? fromCode(String? code) {
    if (code == null) return null;

    for (final value in values) {
      if (value.name != code.toLowerCase()) continue;
      return value;
    }

    return null;
  }
}

/// Entity тега звонка
class TagEntity extends Equatable {
  final String value;
  final int color;
  final TagType? tagType;

  const TagEntity({
    required this.value,
    required this.color,
    this.tagType,
  });

  @override
  List<Object?> get props => [value, color, tagType];
}
