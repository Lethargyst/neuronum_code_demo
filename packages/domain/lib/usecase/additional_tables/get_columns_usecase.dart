import 'package:dartz/dartz.dart';
import 'package:domain/core/failure/failure.dart';
import 'package:domain/entity/common/filter.dart';
import 'package:domain/repository/additional_tables_repository.dart';
import 'package:injectable/injectable.dart';

/// Юзкейс получения колонок доп таблицы
@injectable
class GetColumnsUsecase {
  final AdditionalTablesRepository _repository;

  const GetColumnsUsecase(this._repository);

  Future<Either<Failure, List<Section>>> call({
    required String projectId, 
    required String tableId,
  }) 
    => _repository.getColumns(
      projectId: projectId, 
      tableId: tableId,
    );
}
