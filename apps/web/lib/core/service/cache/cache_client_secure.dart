import 'dart:async';
import 'dart:convert';

import 'package:common/gen/translations.g.dart';
import 'package:core/service/logger/logger.dart';
import 'package:dartz/dartz.dart';
import 'package:domain/service/cache/cache_client.dart';
import 'package:domain/service/cache/cache_client_secure.dart';
import 'package:domain/core/failure/failure.dart';
import 'package:flutter_secure_storage_web/flutter_secure_storage_web.dart';
import 'package:injectable/injectable.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

@Singleton(as: CacheClientSecure)
class WebSecureCacheClientImpl implements CacheClientSecure {
  final AppLogger _logger;

  WebSecureCacheClientImpl(this._logger);

  final _options = {
    "publicKey": "neuronum",
  };

  final _storage = FlutterSecureStorageWeb();

  @override
  Future<void> init() async {}

  @override
  Future<bool> writeData(StorageKey key, CacheObject data) async {
    try {
      await _storage.write(key: key.storageKey, value: data.toJsonString(), options: _options);
      return true;
    } catch (err, trc) {
      _logger.parsing(message: err.toString(), stackTrace: trc);
      return false;
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> loadData(StorageKey key) async {
    try {
      final data = await _storage.read(key: key.storageKey, options: _options);
      if (data == null) return const Right({});

      final json = jsonDecode(data);
      if (json is! Map<String, dynamic>) {
        return Left(
          FailureCache(
            t.errors.wrongData,
            stackTrace: StackTrace.current,
          ),
        );
      }

      return Right(json);
    } catch (err, trc) {
      _logger.parsing(message: err.toString(), stackTrace: trc);
      return Left(FailureParsing(err.toString(), stackTrace: trc));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteData(StorageKey key) async {
    try {
      await _storage.delete(key: key.storageKey, options: _options);
      return const Right(true);
    } catch (err, trc) {
      _logger.parsing(message: err.toString(), stackTrace: trc);
      return Left(FailureCache(err.toString()));
    }
  }

  @override
  Future<bool> containsData(StorageKey key) async {
    try {
      return _storage.containsKey(key: key.storageKey, options: _options);
    } catch (err, trc) {
      _logger.parsing(message: err.toString(), stackTrace: trc);
      return false;
    }
  }
}