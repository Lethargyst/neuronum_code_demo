import 'package:core/service/logger/logger.dart';
import 'package:core/typedefs.dart';
import 'package:dartz/dartz.dart';
import 'package:data/api/filters_api.dart';
import 'package:data/dto/common/filter/filter_dto.dart';
import 'package:data/dto/response/filter_options_dto.dart';
import 'package:domain/core/failure/failure.dart';
import 'package:domain/entity/common/filter.dart';
import 'package:domain/entity/response/filter_options.dart';
import 'package:domain/repository/filters_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: FiltersRepository)
class FiltersRepositoryImpl implements FiltersRepository {
  final FiltersApi _api;
  final AppLogger _logger;

  const FiltersRepositoryImpl(this._api, this._logger);

  @override
  Future<Either<Failure, List<FilterOptions>>> getFiltersOptions(String projectId) async {
    final response = await _api.getFiltersOptions(projectId);
    return response.fold(
      (l) {
        _logger.api(message: l.message, stackTrace: l.stackTrace);
        return Left(l);
      },
      (r) {
        try {
          final data = r.data as Json;
          final dtos = data.entries
            .map(
              (e) => FilterOptionsDto(
                filterId: e.key, 
                options: (e.value as List<dynamic>)
                  .map((e) => e as String)
                  .toList(),
              ),
            )
            .toList(); 
          final entities = dtos.toEntity();

          return Right(entities);
        } catch (err, trc) {
          _logger.parsing(stackTrace: trc, message: err.toString());
          return Left(FailureParsing(err.toString()));
        }
      },
    );
  }

  @override
  Future<Either<Failure, List<FilterEntity>>> getFilters(String projectId) async {
    final response = await _api.getFilters(projectId);
    return response.fold(
      (l) {
        _logger.api(message: l.message, stackTrace: l.stackTrace);
        return Left(l);
      },
      (r) {
        try {
          final data = r.data as List<dynamic>;
          final dtos = data.map((e) => FilterDto.fromJson(e as Json)).toList();
          final entities = dtos.toEntity();

          return Right(entities);
        } catch (err, trc) {
          _logger.parsing(stackTrace: trc, message: err.toString());
          return Left(FailureParsing(err.toString()));
        }
      },
    );
  }
}
