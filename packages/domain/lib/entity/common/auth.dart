import 'dart:convert';

import 'package:domain/service/cache/cache_client.dart';

/// Сущность для хранения данных JWT токена
class AuthData implements CacheObject {
  /// Токен доступа
  final String token;

  /// Токен обновления
  final String refreshToken;

  /// Когда истекает токен доступа
  final DateTime expiresAt;
  
  /// Когда истекает токен обновления
  final DateTime refreshExpiresAt;

  const AuthData({
    required this.token,
    required this.refreshToken,
    required this.expiresAt,
    required this.refreshExpiresAt,
  });

  factory AuthData.fromJson(Map<String, dynamic> data) => AuthData(
        token: data['token'] as String,
        refreshToken: data['refreshToken'] as String,
        expiresAt: DateTime.parse(data['expiresAt'] as String).toLocal(),
        refreshExpiresAt: DateTime.parse(data['refreshExpiresAt'] as String).toLocal(),
      );

  @override
  String toJsonString() => jsonEncode({
        'token': token,
        'refreshToken': refreshToken,
        'expiresAt': expiresAt.toString(),
        'refreshExpiresAt': refreshExpiresAt.toString(),
      });

  bool needAuth() => refreshExpiresAt.isBefore(DateTime.now());

  bool needRefresh() => expiresAt.isBefore(DateTime.now());

  Map<String, String> header() => {'Authorization': 'Bearer $token'};
}
