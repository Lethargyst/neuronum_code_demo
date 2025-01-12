import 'package:dartz/dartz.dart';
import 'package:domain/core/failure/failure.dart';
import 'package:domain/entity/response/filter_options.dart';
import 'package:domain/repository/filters_repository.dart';
import 'package:domain/utils/extensions/either_extension.dart';
import 'package:injectable/injectable.dart';

/// Юзкейс получения опций фильтров
@injectable
class GetFiltersOptionsUsecase {
  final FiltersRepository _repository;

  const GetFiltersOptionsUsecase(this._repository);

  Future<Either<Failure, List<FilterOptions>>> call(String projectId) async {
    final responseResult = await _repository.getFiltersOptions(projectId);

    if (responseResult is Left) return Left(responseResult.asLeft);

    return Right(responseResult.asRight);
  } 
}
