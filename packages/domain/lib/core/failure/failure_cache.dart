part of 'failure.dart';

/// Ошибка, связанная с парсингом данных
final class FailureCache extends Failure {
  FailureCache(super.message, {super.stackTrace});

  @override
  String toString() => super.message;
}
