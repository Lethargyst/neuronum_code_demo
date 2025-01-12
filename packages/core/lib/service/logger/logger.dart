abstract class AppLogger {
  /// Логирование ошибок парсинга
  void parsing({required StackTrace stackTrace, String? message, Object? error});

  /// Логирование ошибок с бэка
  void api({String? message, StackTrace? stackTrace, Object? error});

  /// Логирование прочих ошибок
  void unknown({required String message, required StackTrace stackTrace, Object? error});

  /// Логирование информации
  void info({required String message, StackTrace? stackTrace, Object? error});

  /// Логирование информации об успехе
  void success({required String message, StackTrace? stackTrace, Object? error});

  /// Логирование прочих ошибок
  void error({required String message, StackTrace? stackTrace, Object? error});
}