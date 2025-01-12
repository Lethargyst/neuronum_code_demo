import 'package:core/service/http/base_http.dart';
import 'package:domain/entity/common/auth.dart';

/// Клиент для HTTP запросов с авторизацией
abstract class HttpAuth extends BaseHttp {
  /// Обновить токен доступа
  Future<AuthData?> refreshJwtData([AuthData? oldJwt]);
}
