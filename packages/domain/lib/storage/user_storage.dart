import 'dart:async';

import 'package:domain/entity/common/user.dart';

/// Внутреннее хранилище текущего пользователя
abstract class UserStorage {
  User? get user;

  /// Поток изменений информации о пользователе
  Stream<User> get userChangedStream;

  /// Поток информации об авторизации пользователя
  Stream<User> get logInStream;

  /// Поток информации о выходе из аккаунта пользователем
  Stream<void> get logOutStream;


  void addAuthListener(FutureOr<void> Function() listener);

  void addUnauthListener(FutureOr<void> Function() listener);

  Future<void> init();

  Future<bool> setUser(User? model);
}