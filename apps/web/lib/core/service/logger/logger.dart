import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:core/service/logger/logger.dart';


@Singleton(as: AppLogger)
class WebAppLogger implements AppLogger {
  const WebAppLogger();

  /// Логирование ошибок парсинга
  @override
  Future<void> parsing({required StackTrace stackTrace, String? message, Object? error}) async {
    if (!kDebugMode) return;
    
    Logger().e(
      message ?? 'Ошибка парсинга',
      stackTrace: stackTrace,
      error: error,
      time: DateTime.now(),
    );
  }

  /// Логирование ошибок с бэка
  @override
  Future<void> api({
    StackTrace? stackTrace, String? message, Object? error, bool sendReport = false,
  }) async {
    if (!kDebugMode) return;

    Logger().f(
      message ?? 'Ошибка с бэка',
      stackTrace: stackTrace,
      error: error,
      time: DateTime.now(),
    );
  }

  /// Логирование прочих ошибок
  @override
  Future<void> unknown({
    required String message, required StackTrace stackTrace, Object? error, bool sendReport = true,
  }) async {
    if (!kDebugMode) return;

    Logger().w(message, stackTrace: stackTrace, error: error);
  }

  @override
  void info({required String message, StackTrace? stackTrace, Object? error}) {
    if (!kDebugMode) return;

    Logger(
      printer: PrettyPrinter(
        methodCount: 0,
        levelColors: {Level.info: const AnsiColor.fg(41)},
        levelEmojis: {Level.info: "✅"},
      ),
    ).i(message, stackTrace: stackTrace, error: error);
  }

  @override
  void success({required String message, StackTrace? stackTrace, Object? error}) {
    if (!kDebugMode) return;

    Logger(
      printer: PrettyPrinter(
        methodCount: stackTrace == null ? 0 : 4,
        levelColors: {Level.info: const AnsiColor.fg(41)},
        levelEmojis: {Level.info: "✅"},
      ),
    ).i(message, stackTrace: stackTrace, error: error);
  }

  @override
  void error({required String message, StackTrace? stackTrace, Object? error}) {
    if (!kDebugMode) return;

    Logger(
      printer: PrettyPrinter(
        methodCount: stackTrace == null ? 0 : 4,
        levelColors: {Level.info: const AnsiColor.fg(196)},
        levelEmojis: {Level.info: "❌"},
      ),
    ).i(message, stackTrace: stackTrace, error: error);
  }
}
