import 'package:dartz/dartz.dart';
import 'package:domain/core/failure/failure.dart';
import 'package:domain/entity/common/filter.dart';
import 'package:domain/entity/response/filter_options.dart';

/// Репозиторий для работы с фильтрами
abstract interface class FiltersRepository {
  /// Получить все возможные опции фильтров
  Future<Either<Failure, List<FilterOptions>>> getFiltersOptions(String projectId);

  /// Получить фильтры
  Future<Either<Failure, List<FilterEntity>>> getFilters(String projectId);
}
