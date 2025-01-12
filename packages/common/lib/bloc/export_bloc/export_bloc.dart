import 'package:bloc/bloc.dart';
import 'package:common/gen/translations.g.dart';
import 'package:domain/entity/common/filter.dart';
import 'package:domain/entity/time_range/time_range.dart';
import 'package:injectable/injectable.dart';
import 'package:equatable/equatable.dart';
import 'package:domain/usecase/export/export_usecase.dart';

part 'export_event.dart';
part 'export_state.dart';

/// Блок кнопки экспорта
@injectable
class ExportBloc extends Bloc<ExportEvent, ExportState> {
  final ExportUsecase _usecase;

  ExportBloc(this._usecase) : super(const SuccessState()) {
    on<LoadEvent>(_onLoad);
    on<UpdateFiltersEvent>(_onUpdate);
  }

  late ExportType _type;
  late String _projectId;

  List<FilterEntity> _filters = [];
  TimeRange _timeRange = TimeRange.common();

  void init({required ExportType type, required String projectId}) {
    _type = type;
    _projectId = projectId;
  }

  Future<void> _onLoad(LoadEvent event, Emitter<ExportState> emit) async {
    emit(const LoadingState());

    final result = await _usecase.call(
      type: _type, 
      projectId: _projectId, 
      filters: _filters, 
      interval: _timeRange,
    );
    result.fold(
      (l) => emit(FailureState(t.errors.export(exportType: _type.name))), 
      (r) => emit(const SuccessState()),
    );
  }

  void _onUpdate(UpdateFiltersEvent event, Emitter<ExportState> emit) {
    _filters = event.filters;
    _timeRange = event.timeRange;
  }
}
