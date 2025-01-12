import 'package:core/service/logger/logger.dart';
import 'package:core/typedefs.dart';
import 'package:dartz/dartz.dart';
import 'package:data/api/dashboards_api.dart';
import 'package:data/dto/common/dashboards/dashboard_filters/dashboard_filters_dto.dart';
import 'package:data/dto/common/dashboards/dashboard_response/dashboard_response_dto.dart';
import 'package:data/dto/response/filter_options_dto.dart';
import 'package:domain/core/failure/failure.dart';
import 'package:domain/entity/common/dashboards/dashboard_filters/dashboard_filters.dart';
import 'package:domain/entity/common/dashboards/dashboard_group/dashboard_group.dart';
import 'package:domain/repository/dashboards_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: DashboardsRepository)
class DashboardsRepositoryImpl implements DashboardsRepository {
  final DashboardsApi _api;
  final AppLogger _logger;

  const DashboardsRepositoryImpl(this._api, this._logger);

  @override
  Future<Either<Failure, List<DashboardGroupFilters>>> getDashboards(String projectId) async {
    final response = await _api.getDashboards(projectId);
    return response.fold(
      (l) {
        _logger.api(message: l.message, stackTrace: l.stackTrace);
        return Left(l);
      },
      (r) {
        try {
          final data = r.data as Json;
          final dtos = data.entries
            .map(
              (e) => FilterOptionsDto(
                filterId: e.key, 
                options: (e.value as List<dynamic>)
                  .map((e) => e as String)
                  .toList(),
              ),
            )
            .toList(); 
          final entities = dtos.toEntity();

          return Right(entities);
        } catch (err, trc) {
          _logger.parsing(stackTrace: trc, message: err.toString());
          return Left(FailureParsing(err.toString()));
        }
      },
    );
  }

  @override
  Future<Either<Failure, DashboardGroup>> getDashboardGroup(
    String projectId, 
    DashboardFilters filters,
  ) async {
    final response = await _api.getDashboardGroup(
      projectId, 
      DashboardFiltersDto.fromEntity(filters),
    );
    return response.fold(
      (l) {
        _logger.api(message: l.message, stackTrace: l.stackTrace);
        return Left(l);
      },
      (r) {
        try {
          final data = r.data as List<dynamic>;
          final dtos = DashboardResponseDto.fromJsonList(data);
          final entities = dtos
            .toEntity()
            .map((e) => e.copyWith(
              groupName: filters.group,
              
            ),)
            .toList();

          final group = DashboardGroup(
            name: filters.group, 
            dashboards: entities,
          );
          
          return Right(group);
        } catch (err, trc) {
          _logger.parsing(stackTrace: trc, message: err.toString());
          return Left(FailureParsing(err.toString()));
        }
      },
    );
  }
}
