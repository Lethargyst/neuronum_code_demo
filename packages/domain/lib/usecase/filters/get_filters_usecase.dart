import 'package:dartz/dartz.dart';
import 'package:domain/core/failure/failure.dart';
import 'package:domain/entity/common/filter.dart';
import 'package:domain/repository/filters_repository.dart';
import 'package:injectable/injectable.dart';

/// Юзкейс получения фильтров
@injectable
class GetFiltersUsecase {
  final FiltersRepository _repository;

  const GetFiltersUsecase(this._repository);

  Future<Either<Failure, List<FilterEntity>>> call(String projectId) => 
    _repository.getFilters(projectId);
}
