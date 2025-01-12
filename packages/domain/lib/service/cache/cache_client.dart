import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:domain/core/failure/failure.dart';

/// Ключи доступа к локальному хранилищу
enum StorageKey {
  /// Данные пользователя
  user('user'),

  /// Данные для авторизации
  auth('auth'),
  
  /// Данные фильтров
  filters('filters'),

  /// Данные значений фильтров
  filtersValues('filtersValues');

  final String storageKey;
  const StorageKey(this.storageKey);
}

/// Клиент для кэширования данных
abstract class CacheClient {
  /// Инициализация
  Future<void> init();

  /// Записать данные
  FutureOr<bool> writeData(StorageKey key, CacheObject data);

  /// Загрузить данные
  FutureOr<Either<Failure, dynamic>> loadData(StorageKey key);

  /// Удалить данные
  FutureOr<Either<Failure, bool>> deleteData(StorageKey key);

  /// Содержится ли ключ в хранилище
  FutureOr<bool> containsData(StorageKey key);
}

/// Объект, который необходимо закэшировать
abstract class CacheObject {
  /// Декодер объекта
  String toJsonString();
}
