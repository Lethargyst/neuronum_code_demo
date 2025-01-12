import 'package:core/service/logger/logger.dart';
import 'package:core/typedefs.dart';
import 'package:dartz/dartz.dart';
import 'package:data/api/additional_tables_api.dart';
import 'package:data/dto/common/filter/filter_dto.dart';
import 'package:data/dto/common/time_interval/time_interval_dto.dart';
import 'package:data/dto/response/table_call/table_call_dto.dart';
import 'package:domain/core/failure/failure.dart';
import 'package:domain/entity/common/filter.dart';
import 'package:domain/entity/response/table_call.dart';
import 'package:domain/entity/time_range/time_range.dart';
import 'package:domain/repository/additional_tables_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AdditionalTablesRepository)
class AdditionalTablesRepositroyImpl implements AdditionalTablesRepository {
  final AdditionalTablesApi _api;
  final AppLogger _logger;

  const AdditionalTablesRepositroyImpl(this._api, this._logger);
  
  @override
  Future<Either<Failure, List<TableCall>>> getCalls({
    required List<FilterEntity> filters,
    required TimeRange interval,
    required String projectId,
    required String tableId,
    required int pageSize,
    required int pageNumber,
  }) async {
    final body = {
      'filters': filters.toJson(),
      ...interval.toJson(),
    };
    final response = await _api.getCalls(
      body: body,
      projectId: projectId,
      tableId: tableId,
      pageSize: pageSize,
      pageNumber: pageNumber,
    );
    return response.fold(
      (l) {
        _logger.api(message: l.message, stackTrace: l.stackTrace);
        return Left(l);
      },
      (r) {
        try {
          final dtos = TableCallDto.fromJsonList(r.data as List<dynamic>);
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
  Future<Either<Failure, List<Section>>> getColumns({
    required String projectId,
    required String tableId,
  }) async {
    final response = await _api.getColumns(projectId, tableId);
    return response.fold(
      (l) {
        _logger.api(message: l.message, stackTrace: l.stackTrace);
        return Left(l);
      },
      (r) {
        try {
          final data = r.data as List<dynamic>;
          final dtos = data.map((e) => ColumnDto.fromJson(e as Json)).toList();
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
