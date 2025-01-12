import 'package:dartz/dartz.dart';
import 'package:domain/core/failure/failure.dart';
import 'package:domain/entity/common/dashboards/dashboard_filters/dashboard_filters.dart';
import 'package:domain/entity/common/dashboards/dashboard_group/dashboard_group.dart';
import 'package:domain/repository/dashboards_repository.dart';
import 'package:injectable/injectable.dart';

/// Юзкейс для получения группы дашбордов по фильтрам
@injectable
class GetDashbaordGroupUsecase {
  final DashboardsRepository _repository;

  const GetDashbaordGroupUsecase(this._repository);

  Future<Either<Failure, DashboardGroup>> call({
    required String projectId, 
    required DashboardFilters filters, 
  }) 
    => _repository.getDashboardGroup(projectId, filters);
}
