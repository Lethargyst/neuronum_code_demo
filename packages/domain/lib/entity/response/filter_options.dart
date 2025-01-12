import 'package:equatable/equatable.dart';

/// Entity с опциями фильтра
class FilterOptions extends Equatable {
  /// Айди фильтра
  final String filterId;

  /// Список опций
  final List<String> options;

  const FilterOptions({
    required this.filterId,
    required this.options,
  });

  FilterOptions copyWith({
    String? filterId,
    List<String>? options,
  }) => FilterOptions(
    filterId: filterId ?? this.filterId,
    options: options ?? this.options,
  );

  @override
  List<Object?> get props => [filterId, options];
}
