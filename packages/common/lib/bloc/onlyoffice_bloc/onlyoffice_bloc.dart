import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:equatable/equatable.dart';
import 'package:domain/usecase/onlyoffice/get_onlyoffice_config_usecase.dart';

part 'onlyoffice_event.dart';
part 'onlyoffice_state.dart';

/// Блок экрана онлиофиса
@injectable
class OnlyofficeBloc extends Bloc<OnlyofficeEvent, OnlyofficeState> {
  final GetOnlyofficeConfigUsecase _getConfigUsecase;
  
  OnlyofficeBloc(this._getConfigUsecase) : super(const LoadingState()) {
    on<GetConfigEvent>(_onGetConfig);
  }

  late final String _projectId;

  void init({required String projectId}) => _projectId = projectId;

  Future<void> _onGetConfig(GetConfigEvent event, Emitter<OnlyofficeState> emit) async {
    emit(const LoadingState());

    final result = await _getConfigUsecase.call(
      projectId: _projectId, 
      startDate: event.startDate, 
      endDate: event.endDate,
    );

    result.fold(
      (l) => emit(FailureState(l.message)), 
      (r) => emit(SuccessState(config: r)),
    );
  }
}
