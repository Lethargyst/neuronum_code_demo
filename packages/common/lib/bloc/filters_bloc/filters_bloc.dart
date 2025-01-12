import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:domain/entity/time_range/time_range.dart';
import 'package:domain/storage/filters_storage.dart';
import 'package:domain/utils/extensions/either_extension.dart';
import 'package:domain/entity/common/filter.dart';
import 'package:domain/usecase/filters/get_filters_options_usecase.dart';
import 'package:domain/usecase/filters/get_filters_usecase.dart';
import 'package:domain/utils/extensions/list_extension.dart';
import 'package:injectable/injectable.dart';
import 'package:equatable/equatable.dart';

part 'filters_event.dart';
part 'filters_state.dart';

@injectable
class FiltersBloc extends Bloc<FiltersEvent, FiltersState> {
  /// Юзкейс для получения фильтров
  final GetFiltersUsecase _getFiltersUsecase;

  /// Юзкейс для получения опций фильтров
  final GetFiltersOptionsUsecase _getFiltersOptionsUsecase;

  final FiltersStorage _filtersStorage;

  FiltersBloc(
    this._getFiltersUsecase,
    this._getFiltersOptionsUsecase,
    this._filtersStorage,
  ) : super(const FiltersLoadingState()) {
    on<GetFiltersEvent>(_onGetRemoteFilters);
    on<SetFilterEvent>(_onSetFilter);
    on<SetRangeEvent>(_onSetInterval);
    on<AcceptFiltersEvent>(_onAcceptFilters);
    on<ResetFiltersEvent>(_onResetFilters);
  }

  late String _projectId;

  /// Стрим оповещающий о подверждении фильтров
  final _filtersAcceptNotifier = StreamController<(List<FilterEntity>, TimeRange)>.broadcast();
  Stream<(List<FilterEntity>, TimeRange)> get filtersAcceptNotifier => _filtersAcceptNotifier.stream;

  /// Стрим оповещающий об изменении фильтров
  final _filtersNotifier = StreamController<(List<FilterEntity>, TimeRange)>.broadcast();
  Stream<(List<FilterEntity>, TimeRange)> get filtersNotifier => _filtersNotifier.stream;

  void init(String projectId) => _projectId = projectId;

  Future<void> _onGetRemoteFilters(GetFiltersEvent event, Emitter<FiltersState> emit) async {
    List<FilterEntity> filters;

    emit(const FiltersLoadingState());

    // Получаем фильтры
    final filtersResponse = await _getFiltersUsecase.call(_projectId);
    if (filtersResponse.isLeft()) {
      emit(FiltersFailureState(filtersResponse.asLeft.message));
      return;
    }
    filters = filtersResponse.asRight;

    // Получаем опции для фильтров
    final optionsReponse = await _getFiltersOptionsUsecase.call(_projectId);
    if (optionsReponse.isLeft()) {
      emit(FiltersFailureState(optionsReponse.asLeft.message));
      return;
    }

    for (var i = 0; i < filters.length; ++i) {
      for (final options in optionsReponse.asRight) {
        if (options.filterId == filters[i].id) {
          filters[i] = filters[i].copyWith(options: options);
        }
      }
    }

    // Получаем ранее установленные значения фильтров их кэша
    final filtersIds = filters
      .map((e) => e.id)
      .toList();
    final filtersValues = await _filtersStorage.getFilterValues(filtersIds);
    if (filtersValues != null) {
      for (var i = 0; i < filters.length; ++i) {
        final filterValue = filtersValues.firstWhereOrNull((e) => e.key == filters[i].id);
        filters[i] = filters[i].copyWith(value: filterValue?.value);
      }
    }

    final interval = await _filtersStorage.getTimeRangeValue();

    emit(FiltersSuccessState(filters: filters, interval: interval ?? TimeRange.common()));
  }

  Future<void> _onSetFilter(SetFilterEvent event, Emitter<FiltersState> emit) async {
    final curState = state as FiltersSuccessState;
    curState.filters.edit(event.id, value: event.value, valuesList: event.valuesList);
    _filtersNotifier.add((curState.filters, curState.interval));

    emit(curState);
  }

  void _onSetInterval(SetRangeEvent event, Emitter<FiltersState> emit) {
    final curState = state as FiltersSuccessState;
    final newInterval = curState.interval.copyWith(
      startDate: event.intervalPart == TimeRangePart.startDate ? event.value : null,
      endDate: event.intervalPart == TimeRangePart.endDate ? event.value : null,
      startTime: event.intervalPart == TimeRangePart.startTime ? event.value : null,
      endTime: event.intervalPart == TimeRangePart.endTime ? event.value : null,
    );

    _filtersNotifier.add((curState.filters, curState.interval));
    emit(curState.copyWith(interval: newInterval));
  }

  Future<void> _onAcceptFilters(AcceptFiltersEvent event, Emitter<FiltersState> emit) async {
    final curState = state as FiltersSuccessState;

    await _filtersStorage.saveFilterValuesList(curState.filters);
    _filtersStorage.saveTimeRangeValue(curState.interval);

    _filtersAcceptNotifier.add((curState.filters, curState.interval));
  }

  Future<void> _onResetFilters(ResetFiltersEvent event, Emitter<FiltersState> emit) async {
    final curState = state as FiltersSuccessState;

    _filtersStorage.deleteFilters();

    _filtersAcceptNotifier.add(([], curState.interval));

    final updatedFilters = curState.filters
      .map((e) => e.copyWith(value: null))
      .toList();
    emit(FiltersSuccessState(filters: updatedFilters, interval: TimeRange.common()));
  }

  @override
  Future<void> close() {
    _filtersAcceptNotifier.close();
    _filtersNotifier.close();
    return super.close();
  }
}
