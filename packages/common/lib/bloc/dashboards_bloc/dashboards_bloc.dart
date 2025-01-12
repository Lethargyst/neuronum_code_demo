import 'package:bloc/bloc.dart';
import 'package:domain/entity/common/dashboards/dashboard_group/dashboard_group.dart';
import 'package:domain/usecase/dashboards/get_dashboards_usecase.dart';
import 'package:injectable/injectable.dart';
import 'package:equatable/equatable.dart';

part 'dashboards_event.dart';
part 'dashboards_state.dart';

/// Блок экрана дашбордов
@injectable
class DashboardsBloc extends Bloc<DashboardsEvent, DashboardsState> {
  final GetDashboardsUsecase _getDashboardsUsecase;
  
  DashboardsBloc(this._getDashboardsUsecase) : super(const LoadingState()) {
    on<GetDashboardsEvent>(_onGetDashboards);
  }

  late final String _projectId;

  void init({required String projectId}) {
    _projectId = projectId;
  }

  Future<void> _onGetDashboards(GetDashboardsEvent event, Emitter<DashboardsState> emit) async {
    emit(const LoadingState());

    final result = await _getDashboardsUsecase.call(_projectId);
    result.fold(
      (l) => emit(FailureState(l.message)),
      (r) => emit(SuccessState(options: r)), 
    );
  }
}
