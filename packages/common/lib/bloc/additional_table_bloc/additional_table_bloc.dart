import 'package:bloc/bloc.dart';
import 'package:domain/entity/common/filter.dart';
import 'package:domain/entity/response/table_call.dart';
import 'package:domain/entity/time_range/time_range.dart';
import 'package:domain/usecase/additional_tables/get_calls_usecase.dart';
import 'package:domain/usecase/additional_tables/get_columns_usecase.dart';
import 'package:domain/utils/extensions/either_extension.dart';
import 'package:injectable/injectable.dart';
import 'package:equatable/equatable.dart';

part 'additional_table_event.dart';
part 'additional_table_state.dart';

/// Блок экрана с доп таблицей
@injectable
class AdditionalTableBloc extends Bloc<AdditionalTableEvent, AdditionalTableState> {
  /// Юзкейс получения звонков таблицы
  final GetCallsUsecase _getCallsUsecase;

  /// Юзкейс получения колонок таблицы
  final GetColumnsUsecase _getColumnsUsecase;

  AdditionalTableBloc(
    this._getCallsUsecase, 
    this._getColumnsUsecase,
  ) 
    : super(const LoadingState()) {
      on<InitialFetchEvent>(_onInitialFetch);
    }

  late String _projectId;
  late String _tableId;
  /// Размер страницы
  final int _pageSize = 30;
  /// Выбранный временной промежуток звонков
  final TimeRange _interval = TimeRange.common();
  /// Выбранные фильтры звонков
  /// TODO: Добавить фильтры, когда они повятся на бэке
  final List<FilterEntity> _filters = [];

  void init({required String projectId, required String tableId}) {
    _projectId = projectId;
    _tableId = tableId;
  }

  Future<List<TableCall>> getCalls(int page) async {
    final callsResult = await _getCallsUsecase.call(
      projectId: _projectId,
      tableId: _tableId,
      filters: _filters,
      interval: _interval,
      page: page,
      pageSize: _pageSize,
    );
    return callsResult.fold(
      (l) => [], 
      (r) => r,
    );
  }

  Future<void> _onInitialFetch(InitialFetchEvent event, Emitter<AdditionalTableState> emit) async {
    emit(const LoadingState());

    /// Получаем колонки таблицы
    final columnsResult = await _getColumnsUsecase.call(
      projectId: _projectId,
      tableId: _tableId,
    );
    if (columnsResult.isLeft()) {
      emit(FailureState(columnsResult.asLeft.message));
      return;
    }
    /// Получаем звонки таблицы
    final callsResult = await _getCallsUsecase.call(
      projectId: _projectId,
      tableId: _tableId,
      filters: _filters,
      interval: _interval,
      page: 0,
      pageSize: _pageSize,
    );
    callsResult.fold(
      (l) => emit(FailureState(l.message)), 
      (r) => emit(
        SuccessState(
          firstPageItems: r,
          columns: columnsResult.asRight,
        ),
      ),
    );
  }
}
