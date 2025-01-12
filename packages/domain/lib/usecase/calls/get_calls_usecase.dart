import 'package:dartz/dartz.dart';
import 'package:domain/core/failure/failure.dart';
import 'package:domain/entity/common/call/call.dart';
import 'package:domain/entity/common/filter.dart';
import 'package:domain/entity/time_range/time_range.dart';
import 'package:domain/repository/calls_repository.dart';
import 'package:injectable/injectable.dart';

/// Юзкейс получения звонков
@injectable
class GetCallsUsecase {
  final CallsRepository _repository;

  const GetCallsUsecase(this._repository);

  Future<Either<Failure, (int, List<Call>)>> call({
    required String projectId, 
    required List<FilterEntity> filters,
    required TimeRange interval,
    required int page,
    required int pageSize,
  }) => _repository.getCalls(
    projectId: projectId, 
    filters: filters,
    interval: interval,
    page: page,
    pageSize: pageSize,
  );
}
