import 'package:core/service/logger/logger.dart';
import 'package:domain/entity/common/auth.dart';
import 'package:domain/service/cache/cache_client.dart';
import 'package:domain/service/cache/cache_client_secure.dart';
import 'package:domain/storage/auth_data_storage.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: AuthDataStorage)
class JwtStorage implements AuthDataStorage {
  final AppLogger _logger;
  final CacheClientSecure _secureStorage;

  JwtStorage(this._logger, this._secureStorage);

  AuthData? _currentJwt;

  @override
  Future<AuthData?> getAuthData() async {
    if (_currentJwt != null) return _currentJwt;

    final data = await _secureStorage.loadData(StorageKey.auth);
    return data.fold(
      (l) => null,
      (r) {
        try {
          final data = r as Map<String, dynamic>;
          if (data.isEmpty) return null;

          final model = AuthData.fromJson(data);
          _currentJwt = model;
          return model;
        } catch (err, trc) {
          _logger.parsing(message: err.toString(), stackTrace: trc);
          return null;
        }
      },
    );
  }

  @override
  Future<bool> saveAuthData(AuthData data) async {
    final result = await _secureStorage.writeData(StorageKey.auth, data);
    _currentJwt = data;
    return result;
  }

  @override
  Future<bool> clearData() async {
    final result = await _secureStorage.deleteData(StorageKey.auth);
    if (result.isLeft()) return false;

    _currentJwt = null;
    return true;
  }
}
