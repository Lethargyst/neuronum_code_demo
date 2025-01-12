import 'package:domain/entity/response/filter_options.dart';

/// DTO опций фильтра
class FilterOptionsDto {
  /// Айди фильтра
  final String filterId;

  /// Список опций
  final List<String> options;

  const FilterOptionsDto({
    required this.filterId,
    required this.options,
  });

  FilterOptions toEntity() => FilterOptions(
    filterId: filterId,
    options: options,
  );
}

extension Parser on List<FilterOptionsDto> {
  List<FilterOptions> toEntity() => map((e) => e.toEntity()).toList();
}