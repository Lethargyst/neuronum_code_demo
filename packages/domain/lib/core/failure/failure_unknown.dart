part of 'failure.dart';

/// Неизвестная ошибка
final class FailureUnknown extends Failure {
  FailureUnknown(super.message, {super.stackTrace});

  @override
  String toString() => super.message;
}
