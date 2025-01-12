import 'package:core/service/logger/logger.dart';
import 'package:dartz/dartz.dart';
import 'package:data/api/{{repository_name.snakeCase()}}_api.dart';
import 'package:domain/core/failure/failure.dart';
import 'package:domain/repository/{{repository_name.snakeCase()}}_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: {{repository_name.pascalCase()}}Repository)
class {{repository_name.pascalCase()}}RepositoryImpl implements {{repository_name.pascalCase()}}Repository {
  final {{repository_name.pascalCase()}}Api _api;
  final AppLogger _logger;

  const {{repository_name.pascalCase()}}RepositoryImpl(this._api, this._logger);

  @override
  Future<Either<Failure, dynamic>> exampleMethod() async {
    final response = await _api.exampleMethod();
    return response.fold(
      (l) {
        _logger.api(message: l.message, stackTrace: l.stackTrace);
        return Left(l);
      },
      (r) {
        try {

          return const Right(null);
        } catch (err, trc) {
          _logger.parsing(stackTrace: trc, message: err.toString());
          return Left(FailureParsing(err.toString()));
        }
      },
    );
  }
}
