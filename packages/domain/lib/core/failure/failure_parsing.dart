part of 'failure.dart';

/// Ошибка, связанная с парсингом данных
final class FailureParsing extends Failure {
  FailureParsing(super.message, {super.stackTrace});

  @override
  String toString() => super.message;
}
