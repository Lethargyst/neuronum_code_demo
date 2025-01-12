import 'package:bloc/bloc.dart';
import 'package:domain/entity/common/filter.dart';
import 'package:domain/entity/common/call/call.dart';
import 'package:domain/entity/time_range/time_range.dart';
import 'package:injectable/injectable.dart';
import 'package:equatable/equatable.dart';
import 'package:domain/usecase/calls/get_calls_usecase.dart';
import 'package:domain/usecase/filters/get_cached_filters_values_usecase.dart';
import 'package:domain/usecase/filters/get_cached_time_range_value_usecase.dart';

part 'calls_event.dart';
part 'calls_state.dart';

/// Блок для страницы звонков
@injectable
class CallsBloc extends Bloc<CallsEvent, CallsState> {
  /// Юзкейс для получения звонков
  final GetCallsUsecase _getCallsUsecase;
  /// Юзкейс для получения закэшированных значений фильтров
  final GetCachedFiltersValuesUsecase _getCachedFiltersValuesUsecase;
  /// Юзкейс для получения закэшированного значения промежутка времени для фильтра
  final GetCachedTimeRangeValueUsecase _getCachedTimeRangeValueUsecase;

  CallsBloc(
    this._getCallsUsecase,
    this._getCachedFiltersValuesUsecase,
    this._getCachedTimeRangeValueUsecase,
  )
    : super(const LoadingState()) {
      on<GetCallsEvent>(_onGetCalls);
      on<UpdateCallEvent>(_onUpdateCall);
      on<SetFiltersEvent>(_onSetFilters);
      on<PaginationEvent>(_onPagination);
    }

  late String _projectId;
  /// Размер страницы
  final int _pageSize = 20;
  /// Выбранный временной промежуток звонков
  TimeRange _interval = TimeRange.common();
  /// Выбранные фильтры звонков
  List<FilterEntity> _filters = [];

  void init(String projectId) => _projectId = projectId;

  Future<List<FilterEntity>> _getCachedFilters() async {
    final filtersValues = await _getCachedFiltersValuesUsecase.call();
    if (filtersValues == null) return [];

    final filters = filtersValues
      .map(FilterEntity.fromProp)
      .toList();

    return filters;
  }

  Future<TimeRange> _getCachedTimeRange() async {
    final value = await _getCachedTimeRangeValueUsecase.call();
    if (value == null) return TimeRange.common();

    return value;
  }

  Future<void> _onGetCalls(GetCallsEvent event, Emitter<CallsState> emit) async {
    emit(const LoadingState());

    if (event.withInitialFilters) {
      _filters = await _getCachedFilters();
      _interval = await _getCachedTimeRange();
    }

    final result = await _getCallsUsecase.call(
      projectId: _projectId,
      filters: _filters,
      interval: _interval,
      page: 0,
      pageSize: _pageSize,
    );
    result.fold(
      (l) => emit(FailureState(l.message)), 
      (r) {
        final totalCallsCount = r.$1;
        final calls = r.$2;

        emit(
          SuccessState(
            items: calls, 
            totalItemsCount: totalCallsCount,
            nextPage: calls.length >= _pageSize ? 1 : null,
          ),
        );
      },
    );
  }

  void _onUpdateCall(UpdateCallEvent event, Emitter<CallsState> emit) {
    final curState = state as SuccessState;
    final items = curState.items;

    for (var i = 0; i < items.length; ++i) {
      if (items[i].id != event.call.id) continue;
      items[i] = event.call;
    }
    emit(curState.copyWith(items: [...items]));
  }

  void _onSetFilters(SetFiltersEvent event, Emitter<CallsState> emit) {
    _interval = event.interval;
    _filters = event.filters;
    add(const GetCallsEvent());
  }

  Future<void> _onPagination(PaginationEvent event, Emitter<CallsState> emit) async {
    if (state is! SuccessState) return;
    if ((state as SuccessState).nextPage == null) return;
    if ((state as SuccessState).isPaginating) return;

    final curState = state as SuccessState;
    emit(curState.copyWith(isPaginating: true));

    final response = await _getCallsUsecase.call(
      projectId: _projectId,
      filters: _filters,
      interval: _interval,
      page: curState.nextPage!,
      pageSize: _pageSize,
    );
    response.fold(
      (l) => emit(curState.copyWith(paginationError: l.message)),
      (r) {
        final totalCallsCount = r.$1;
        final calls = r.$2;

        curState.items.addAll(calls);

        final nextPage = calls.length < _pageSize ? null : curState.nextPage! + 1; 
        emit(
          SuccessState(
            items: curState.items, 
            totalItemsCount: totalCallsCount,
            nextPage: nextPage,
          ),
        );
      },
    );
  }
}
