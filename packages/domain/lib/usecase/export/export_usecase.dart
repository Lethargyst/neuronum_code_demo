import 'package:dartz/dartz.dart';
import 'package:domain/core/failure/failure.dart';
import 'package:domain/entity/common/filter.dart';
import 'package:domain/entity/time_range/time_range.dart';
import 'package:domain/repository/export_repository.dart';
import 'package:injectable/injectable.dart';

enum ExportType {
  excel,
  csv,
}

/// Юзкейс для экспорта
@injectable
class ExportUsecase {
  final ExportRepository _repository;

  const ExportUsecase(this._repository);

  Future<Either<Failure, bool>> call({
    required ExportType type,
    required String projectId,
    required List<FilterEntity> filters,
    required TimeRange interval,
  }) {
    final handler = switch (type) {
      ExportType.excel => _repository.downloadExcel,
      ExportType.csv => _repository.downloadCsv,
    };

    return handler.call(
      projectId: projectId,
      filters: filters,
      interval: interval,
    );
  }
}
