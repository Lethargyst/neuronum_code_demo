import 'package:bloc/bloc.dart';
import 'package:domain/entity/common/dashboards/dashboard_filters/dashboard_filters.dart';
import 'package:domain/entity/common/dashboards/dashboard_group/dashboard_group.dart';
import 'package:domain/entity/common/filter.dart';
import 'package:domain/entity/time_range/time_range.dart';
import 'package:domain/storage/filters_storage.dart';
import 'package:domain/usecase/dashboards/get_dashboard_group.dart';
import 'package:injectable/injectable.dart';
import 'package:equatable/equatable.dart';

part 'dashboard_group_event.dart';
part 'dashboard_group_state.dart';

/// Блок группы дашбордов
@injectable
class DashboardGroupBloc extends Bloc<DashboardGroupEvent, DashboardGroupState> {
  final GetDashbaordGroupUsecase _getDashboardGroupUsecase;
  final FiltersStorage _filtersStorage;
  
  DashboardGroupBloc(
    this._getDashboardGroupUsecase, 
    this._filtersStorage,
  ) : super(const LoadingState()) {
    on<GetDashboardGroupEvent>(_onGetDashboardGroup);
    on<AcceptGroupFiltersEvent>(_onAcceptFilters);
  }

  late final String _projectId;
  late final String _group;
  /// Редактируемы фильтры
  late final List<FilterEntity> _filters;
  /// Фильтры на отправку
  var _acceptedFilters = DashboardFilters.empty(); 

  void init({
    required String projectId, 
    required String group,
    required List<String> filtersIds,
  }) {
    _projectId = projectId;
    _group = group;
  }

  Future<void> _onGetDashboardGroup(
    GetDashboardGroupEvent event, 
    Emitter<DashboardGroupState> emit,
  ) async {
    emit(const LoadingState());
    _acceptedFilters = _acceptedFilters.copyWith(group: _group);

    final result = await _getDashboardGroupUsecase.call(
      projectId: _projectId, 
      filters: _acceptedFilters,
    );
    result.fold(
      (l) => emit(FailureState(l.message)),
      (r) => emit(SuccessState(filters: _filters, dashboardGroup: r)),
    );
  }

  Future<void> _onAcceptFilters(
    AcceptGroupFiltersEvent event, 
    Emitter<DashboardGroupState> emit,
  ) async {
    final filterOptions = <String>[];
    for (final filter in event.filters) {
      if (filter.valuesList == null) continue;
      filterOptions.addAll(filter.valuesList!);
    } 
    _acceptedFilters = _acceptedFilters.copyWith(
      filters: filterOptions,
      startDate: event.timeRange.startDate,
      endDate: event.timeRange.endDate,
    );

    add(const GetDashboardGroupEvent());
  }
}
