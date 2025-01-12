import 'package:dartz/dartz.dart';
import 'package:domain/core/failure/failure.dart';
import 'package:domain/entity/common/filter.dart';
import 'package:domain/entity/time_range/time_range.dart';
import 'package:domain/repository/export_repository.dart';
import 'package:injectable/injectable.dart';

/// Юзкейс для экспорта csv 
@injectable
class ExportCsvUsecase {
  final ExportRepository _repository;

  const ExportCsvUsecase(this._repository);

  Future<Either<Failure, bool>> call({
    required String projectId, 
    required List<FilterEntity> filters, 
    required TimeRange interval,
  }) =>
     _repository.downloadCsv(
      projectId: projectId,
      filters: filters,
      interval: interval,
     );
}
