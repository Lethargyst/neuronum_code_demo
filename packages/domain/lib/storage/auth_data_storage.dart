
import 'package:domain/entity/common/auth.dart';

/// Внутренне хранилище для данных авторизации
abstract class AuthDataStorage {
  Future<AuthData?> getAuthData();

  Future<bool> saveAuthData(AuthData data);

  Future<bool> clearData();
}