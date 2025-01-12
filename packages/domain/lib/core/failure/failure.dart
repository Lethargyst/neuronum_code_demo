// ignore_for_file: library_names

/// {@category Domain.Core}

library Failure;

part 'failure_api.dart';
part 'failure_parsing.dart';
part 'failure_unknown.dart';
part 'failure_unauth.dart';
part 'failure_cache.dart';

/// Ошибки в работе приложения
abstract class Failure implements Exception {
  /// Текст ошибки
  final String message;

  /// Стактрейс для отслеживания
  final StackTrace? stackTrace;

  Failure(
    this.message, {
    this.stackTrace,
  });

  @override
  String toString() => message;
}
