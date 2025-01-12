import 'dart:async';
import 'dart:convert';

import 'package:core/service/logger/logger.dart';
import 'package:data/dto/common/time_interval/time_interval_dto.dart';
import 'package:domain/entity/common/filter.dart';
import 'package:domain/entity/response/prop.dart';
import 'package:domain/entity/time_range/time_range.dart';
import 'package:domain/service/cache/manager/cache_filters_manager.dart';
import 'package:domain/storage/filters_storage.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: FiltersStorage)
final class FiltersStorageImpl implements FiltersStorage {
  final CacheFiltersManager _cacheManager;
  final AppLogger _logger;

  FiltersStorageImpl(this._cacheManager, this._logger);

  @override
  FutureOr<bool> saveTimeRangeValue(TimeRange value) {
    final json = jsonEncode(TimeRangeDto.fromEntity(value).toJson());
    final prop = Prop(
      key: 'timeRange', 
      value: json,
    );

    return _cacheManager.saveFilterValueSingle(prop);
  }

  @override
  Future<TimeRange?> getTimeRangeValue() async {
    try {
      final prop = (await _cacheManager.loadFiltersValues(['timeRange']))?.first;
      if (prop == null) return null;

      final jsonData = json.decode(prop.value) as Map<String, dynamic>;
      final dto = TimeRangeDto.fromJson(jsonData);
      final result = dto.toEntity();
      
      return result;
    } catch (err, trc) {
      _logger.error(message: err.toString(), stackTrace: trc);
      return null;
    }
  }
 
  @override
  FutureOr<bool> saveFilterValueSingle(FilterEntity filterValue) {
    final prop = Prop(key: filterValue.id, value: filterValue.value ?? '');
    
    return _cacheManager.saveFilterValueSingle(prop);
  }

  @override
  FutureOr<bool> saveFilterValuesList(List<FilterEntity> filterValues) {
    final props = filterValues
      .map((e) => Prop(key: e.id, value: e.value ?? ''))
      .toList();

    return  _cacheManager.saveFilterValuesList(props);
  }
  
  @override
  Future<List<Prop>?> getFilterValues([List<String>? ids]) async {
    try {
      return _cacheManager.loadFiltersValues(ids);
    } catch (err, trc) {
      _logger.error(message: err.toString(), stackTrace: trc);
      return null;
    }
  }

  @override
  Future<bool> deleteFilters() async {
    try {
      _cacheManager.deleteFilters();
      return true;
    } catch (err, trc) {
      _logger.error(message: err.toString(), stackTrace: trc);
      return false;
    }
  }
}