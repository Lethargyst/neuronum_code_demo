import 'dart:async';
import 'dart:convert';

import 'package:core/service/logger/logger.dart';
import 'package:dartz/dartz.dart';
import 'package:domain/core/failure/failure.dart';
import 'package:domain/service/cache/cache_client.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Реализацие кэш-сервиса с помощью пакета [SharedPreferences]
@Singleton(as: CacheClient)
class CacheClientSfImpl implements CacheClient {
  final AppLogger _logger;

  CacheClientSfImpl(this._logger);

  late final SharedPreferences _prefs;

  @override
  Future<void> init() async => _prefs = await SharedPreferences.getInstance();

  @override
  Future<bool> writeData(StorageKey key, CacheObject data) async {
    try {
      final result = await _prefs.setString(key.name, data.toJsonString());
      _logger.success(message: "SharedPreferences: успешно сохранено ${key.name}: ${data.toJsonString()}");
      return result;
    } catch (err, trc) {
      _logger.error(message: err.toString(), stackTrace: trc);
      return false;
    }
  }

  @override
  FutureOr<Either<Failure, dynamic>> loadData(StorageKey key) async {
    try {
      final value = _prefs.getString(key.name);
      if (value == null) return const Right(null);

      final data = jsonDecode(value);
      return Right(data); 
    } on FormatException catch (err, trc) {
      final error = "SharedPreferences: Ошибка парсинга: $err";
      _logger.parsing(
        stackTrace: trc,
        message: error,
      );
      return Left(FailureParsing(error, stackTrace: trc));
    } catch (err, trc) {
      _logger.error(message: err.toString(), stackTrace: trc);
      return Left(FailureCache(err.toString(), stackTrace: trc));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteData(StorageKey key) async {
    try {
      return Right(await _prefs.remove(key.name));
    } catch (err, trc) {
      _logger.error(message: err.toString(), stackTrace: trc);
      return Left(FailureCache(err.toString(), stackTrace: trc));
    }
  }

  @override
  FutureOr<bool> containsData(StorageKey key) async {
    try {
      return _prefs.containsKey(key.name);
    } catch (err, trc) {
      _logger.error(message: err.toString(), stackTrace: trc);
      return false;
    }
  }
}
