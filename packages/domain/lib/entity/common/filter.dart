import 'package:domain/entity/response/filter_options.dart';
import 'package:domain/entity/response/prop.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'filter.freezed.dart';

typedef Section = FilterEntity;

/// Entity фильтра
@freezed
class FilterEntity with _$FilterEntity {
  const factory FilterEntity({
    /// Айди фильтра
    required String id,

    /// Имя фильтра
    String? name,

    /// Выбранное значение фильтра
    String? value,

    /// Выбранные значения списком (нужно для фильтров с чекбоксами)
    List<String>? valuesList,

    /// Значения фильтра
    FilterOptions? options,
  }) = _FilterEntity;

  factory FilterEntity.fromProp(Prop prop) => FilterEntity(
    id: prop.key, 
    value: prop.value,
    name: '',
  ); 
}

extension FilterHelper on FilterEntity {
  FilterEntity updateValue(String? value) => copyWith(value: value);

  FilterEntity updateValuesList(List<String>? values) => copyWith(valuesList: valuesList);

}
extension FilterListHelper on List<FilterEntity> {
  List<String> get ids => map((e) => e.id).toList();
  List<String> get names => map((e) => e.name ?? '').toList();

  void edit(
    String filterId, {
    String? value,
    List<String>? valuesList,
  }) {
    editSingleValue(filterId, value);
    editMultipleValue(filterId, valuesList); 
  }

  /// Изменить значение [value] у [FilterEntity] c айди [filterId]
  void editSingleValue(String filterId, String? value) {
    for (var i = 0; i < length; ++i) {
      if (this[i].id == filterId) {
        this[i] = this[i].updateValue(value);
      }
    }
  }

  /// Изменить значение [valuesList] у [FilterEntity] c айди [filterId]
  void editMultipleValue(String filterId, List<String>? valuesList) {
    for (var i = 0; i < length; ++i) {
      if (this[i].id == filterId) {
        this[i] = this[i].updateValuesList(valuesList);
      }
    }
  }
}