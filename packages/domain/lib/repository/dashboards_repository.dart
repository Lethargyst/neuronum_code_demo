import 'package:dartz/dartz.dart';
import 'package:domain/core/failure/failure.dart';
import 'package:domain/entity/common/dashboards/dashboard_filters/dashboard_filters.dart';
import 'package:domain/entity/common/dashboards/dashboard_group/dashboard_group.dart';

/// Репозиторий для работы с дашбордами
abstract interface class DashboardsRepository {
  /// Получить группы дашбородов и их фильтры
  Future<Either<Failure, List<DashboardGroupFilters>>> getDashboards(String projectId);

  /// Получить дашборд по его группе и фильтрам
  Future<Either<Failure, DashboardGroup>> getDashboardGroup(
    String projectId, 
    DashboardFilters filters,
  );
}
