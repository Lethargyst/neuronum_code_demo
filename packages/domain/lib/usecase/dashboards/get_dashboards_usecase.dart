import 'package:dartz/dartz.dart';
import 'package:domain/core/failure/failure.dart';
import 'package:domain/entity/common/dashboards/dashboard_group/dashboard_group.dart';
import 'package:domain/repository/dashboards_repository.dart';
import 'package:injectable/injectable.dart';

/// Юзкейс для получения групп дашбордов
@injectable
class GetDashboardsUsecase {
  final DashboardsRepository _repository;

  const GetDashboardsUsecase(this._repository);

  Future<Either<Failure, List<DashboardGroupFilters>>> call(String projectId) =>
    _repository.getDashboards(projectId);
}
