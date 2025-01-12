import 'package:dartz/dartz.dart';
import 'package:domain/core/failure/failure.dart';

/// Описание репозитория
abstract interface class {{repository_name.pascalCase()}}Repository {
  /// Описание метода
  Future<Either<Failure, dynamic>> exampleMethod();
}
