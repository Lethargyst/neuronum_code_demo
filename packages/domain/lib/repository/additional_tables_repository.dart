import 'package:dartz/dartz.dart';
import 'package:domain/core/failure/failure.dart';
import 'package:domain/entity/common/filter.dart';
import 'package:domain/entity/response/table_call.dart';
import 'package:domain/entity/time_range/time_range.dart';

/// Репозиторий для работы с доп таблицами
abstract interface class AdditionalTablesRepository {
  Future<Either<Failure, List<TableCall>>> getCalls({
    required List<FilterEntity> filters,
    required TimeRange interval,
    required String projectId,
    required String tableId,
    required int pageSize,
    required int pageNumber,
  });

  Future<Either<Failure, List<Section>>> getColumns({
    required String projectId, 
    required String tableId,
  });
}
