import 'package:dartz/dartz.dart';
import 'package:domain/core/failure/failure.dart';
import 'package:domain/entity/common/filter.dart';
import 'package:domain/entity/response/table_call.dart';
import 'package:domain/entity/time_range/time_range.dart';
import 'package:domain/repository/additional_tables_repository.dart';
import 'package:injectable/injectable.dart';

/// Юзкейс получения звонков доп таблицы
@injectable
class GetCallsUsecase {
  final AdditionalTablesRepository _repository;

  const GetCallsUsecase(this._repository);

  Future<Either<Failure, List<TableCall>>> call({
    required String projectId, 
    required String tableId,
    required List<FilterEntity> filters,
    required TimeRange interval,
    required int page,
    required int pageSize,
  }) => _repository.getCalls(
    projectId: projectId, 
    tableId: tableId,
    filters: filters,
    interval: interval,
    pageNumber: page,
    pageSize: pageSize,
  );
}
