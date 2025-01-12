part of 'failure.dart';

/// Ошибка "Нет авторизации"
final class FailureUnauth extends Failure {
  FailureUnauth() : super("");

  @override
  String toString() => super.message;
}
