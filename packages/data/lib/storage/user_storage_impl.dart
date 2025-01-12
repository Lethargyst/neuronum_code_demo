import 'dart:async';
import 'package:domain/entity/common/user.dart';
import 'package:domain/service/cache/manager/cache_user_manager.dart';
import 'package:domain/storage/user_storage.dart';
import 'package:injectable/injectable.dart';

/// Внутреннее хранилище текущего пользователя
@Singleton(as: UserStorage)
class UserStorageImpl implements UserStorage {
  final CacheUserManager _cacheClient;

  UserStorageImpl(this._cacheClient);

  /// Контроллер для потока изменений информации о пользователе
  final StreamController<User> _userChangedController = StreamController.broadcast();

  /// Контроллер для потока информации об авторизации пользователя
  final StreamController<User> _logInController = StreamController.broadcast();

  /// Контроллер для потока информации о выходе из аккаунта пользователем
  final StreamController<void> _logOutController = StreamController.broadcast();

  /// Поток изменений информации о пользователе
  @override
  Stream<User> get userChangedStream => _userChangedController.stream;

  /// Поток информации об авторизации пользователя
  @override
  Stream<User> get logInStream => _logInController.stream;

  /// Поток информации о выходе из аккаунта пользователем
  @override
  Stream<void> get logOutStream => _logOutController.stream;

  /// Future слушатели для авторизации пользователя
  final _authListeners = <FutureOr<void> Function()>[];

  /// Future слушатели для разавторизации пользователя
  final _unauthListeners = <FutureOr<void> Function()>[];

  User? _user;

  @override
  void addAuthListener(FutureOr<void> Function() listener) => _authListeners.add(listener);

  @override
  void addUnauthListener(FutureOr<void> Function() listener) => _unauthListeners.add(listener);

  @override
  User? get user => _user;

  @override
  Future<void> init() async {
    _user = await (await _cacheClient.loadUser()).fold(
      (l) => null,
      (user) async {
        if (user != null) {
          _logInController.add(user);
          for (final listener in _authListeners) {
            await listener.call();
          }
        }

        return user;
      },
    );
  }

  @override
  Future<bool> setUser(User? model) async {
    if (model == null) {
      await _cacheClient.deleteUser();
    } else {
      final saved = await _cacheClient.saveUser(model);
      if (_user == null && !saved) return false;
    }

    final previous = _user;
    _user = model;

    // Если пользователь был null, а теперь нет - кидаем инфу об авторизации
    if (previous == null && model != null) {
      _logInController.add(model);
      for (final listener in _authListeners) {
        await listener.call();
      }
    }

    // Если пользователь не был null, а теперь стал - кидаем инфу о выходе из аккаунта
    else if (previous != null && model == null) {
      _logOutController.add(null);
      for (final listener in _unauthListeners) {
        await listener.call();
      }
    }

    // Если инфа о пользователе была изменена - кидаем инфу об изменении пользователя
    else if (previous != null && model != null) {
      _userChangedController.add(model);
    }
    return true;
  }
}