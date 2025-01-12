import 'dart:async';

import 'package:domain/entity/common/filter.dart';
import 'package:domain/entity/response/prop.dart';
import 'package:domain/entity/time_range/time_range.dart';

/// Рантайм хранилище фильтров
abstract class FiltersStorage {
  FutureOr<bool> saveTimeRangeValue(TimeRange value);

  Future<TimeRange?> getTimeRangeValue();
  
  FutureOr<bool> saveFilterValueSingle(FilterEntity filterValue);

  FutureOr<bool> saveFilterValuesList(List<FilterEntity> filterValues);

  Future<List<Prop>?> getFilterValues([List<String>? ids]);

  Future<bool> deleteFilters();
}