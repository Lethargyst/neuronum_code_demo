import 'package:dartz/dartz.dart';
import 'package:domain/core/failure/failure.dart';
import 'package:domain/entity/common/filter.dart';
import 'package:domain/entity/time_range/time_range.dart';

/// Репозитерий для экспорта звонков
abstract interface class ExportRepository {
  /// Загрузить excel
  Future<Either<Failure, bool>> downloadExcel({
    required String projectId, 
    required List<FilterEntity> filters,
    required TimeRange interval,
  });

  /// Загрузить csv
  Future<Either<Failure, bool>> downloadCsv({
    required String projectId, 
    required List<FilterEntity> filters,
    required TimeRange interval,
  });
}
