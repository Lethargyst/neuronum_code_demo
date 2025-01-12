import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:js_interop';

import 'package:core/service/logger/logger.dart';
import 'package:dartz/dartz.dart';
import 'package:data/dto/response/prop/prop_dto.dart';
import 'package:domain/core/failure/failure.dart';
import 'package:domain/entity/response/prop.dart';
import 'package:domain/service/cache/cache_client.dart';
import 'package:domain/service/cache/manager/cache_filters_manager.dart';
import 'package:domain/utils/extensions/list_extension.dart';
import 'package:injectable/injectable.dart';

/// Менеджер для кеширования фильтров
@Injectable(as: CacheFiltersManager)
class CacheFiltersManagerImpl extends CacheFiltersManager {
  final CacheClient _cacheClientSecure;
  final AppLogger _logger;

  CacheFiltersManagerImpl(this._cacheClientSecure, this._logger);

  @override
  FutureOr<bool> saveFilterValueSingle(Prop filter) async {
    var currentFilters = <Prop>[];
    final currentFiltersResult = await loadFiltersValues();

    if (currentFiltersResult != null) {
      currentFilters = currentFiltersResult;
      currentFilters.removeWhere((e) => e.key == filter.key);
    }

    final filtersToWrite = [...currentFilters, filter];
    return _cacheClientSecure.writeData(
      StorageKey.filtersValues, 
      PropsListCache(filtersToWrite),
    );
  }

  @override
  FutureOr<bool> saveFilterValuesList(List<Prop> filters) async {
    var currentFilters = <Prop>[];

    final currentFiltersResult = await loadFiltersValues();
    if (currentFiltersResult != null) {
      currentFilters = currentFiltersResult;
      currentFilters.removeWhere(
        (filter) => filters.firstWhereOrNull((e) => e.key == filter.key) != null,
      );
    }

    final filtersToWrite = [...currentFilters, ...filters];
    return _cacheClientSecure.writeData(
      StorageKey.filtersValues, 
      PropsListCache(filtersToWrite),
    );
  }

  @override
  Future<List<Prop>?> loadFiltersValues([List<String>? ids]) async {
    final result = await _cacheClientSecure.loadData(StorageKey.filtersValues);
    return result.fold(
      (l) {
        _logger.error(message: l.message, stackTrace: l.stackTrace);
        return null;
      },
      (r) {
        try {
          if (r == null) return null;

          final data = (jsonDecode(r as String) as JSArray).toDart;
          final dtos = PropDto.fromJsonList(data);

          var filteredDtos = dtos;
          if (ids != null) {
            final idsSet = HashSet<String>.from(ids);
            filteredDtos = dtos
              .where((e) => idsSet.contains(e.key))
              .toList();
          }

          return filteredDtos.toEntity();
        } catch (err, trc) {
          _logger.parsing(stackTrace: trc, error: err);
          return null;
        }
      },
    );
  }

  @override
  Future<Either<Failure, bool>> deleteFilters() async => 
    _cacheClientSecure.deleteData(StorageKey.filtersValues);
}
