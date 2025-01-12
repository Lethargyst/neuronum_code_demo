import 'package:common/bloc/filters_bloc/filters_bloc.dart';
import 'package:domain/entity/time_range/time_range.dart';
import 'package:domain/usecase/export/export_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lvm_telephony_web/gen/translations.g.dart';
import 'package:lvm_telephony_web/utils/extensions/build_context.dart';
import 'package:lvm_telephony_web/widgets/app_scroll/app_scroll_wrapper.dart';
import 'package:lvm_telephony_web/widgets/buttons/app_button.dart';
import 'package:lvm_telephony_web/widgets/buttons/export_button.dart';
import 'package:lvm_telephony_web/widgets/common/loader.dart';
import 'package:lvm_telephony_web/widgets/common/spacers.dart';
import 'package:lvm_telephony_web/widgets/filters/sample_filter.dart';
import 'package:lvm_telephony_web/widgets/filters/date_filter.dart';
import 'package:lvm_telephony_web/widgets/filters/time_filter.dart';
import 'package:lvm_telephony_web/widgets/text/app_text.dart';

/// Список фильтров
class FiltersList extends StatelessWidget {
  final bool exportEnabled;

  const FiltersList({ 
    this.exportEnabled = true,
    super.key,
  });

  void _onSetFilter(FiltersBloc bloc, String filterId, {String? value, List<String>? valuesList}) => 
    bloc.add(SetFilterEvent(filterId, value: value, valuesList: valuesList)); 

  void _onSetDateRange(FiltersBloc bloc, DateTime start, DateTime end) {
    bloc.add(SetRangeEvent(TimeRangePart.startDate, start)); 
    bloc.add(SetRangeEvent(TimeRangePart.endDate, end)); 
  }
  
  void _onSetTimeStart(FiltersBloc bloc, DateTime value) =>
    bloc.add(SetRangeEvent(TimeRangePart.startTime, value)); 

  void _onSetTimeEnd(FiltersBloc bloc, DateTime value) =>
    bloc.add(SetRangeEvent(TimeRangePart.endTime, value)); 

  void _onAccept(FiltersBloc bloc) => bloc.add(const AcceptFiltersEvent()); 

  void _onReset(FiltersBloc bloc) => bloc.add(const ResetFiltersEvent());

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<FiltersBloc>();
    
    return LayoutBuilder(
      builder: (context, constraints) => Container(
        height: constraints.maxHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: context.theme.colorScheme.tertiary,
          boxShadow: [
            BoxShadow(
              color: context.theme.colorScheme.onSurfaceVariant,
              blurRadius: 10,
            ),
          ],
        ),
        child: BlocBuilder<FiltersBloc, FiltersState>(
          builder: (context, state) => switch (state) {
            FiltersSuccessState() => Stack(
              children: [
                AppScrollWrapper(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      key: ValueKey(state.filters.hashCode),
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SpacerV(16),
                        DateFilter(
                          onSelect: (start, end) => _onSetDateRange(bloc, start, end),
                          initialValue: DateTimeRange(
                            start: state.interval.startDate, 
                            end: state.interval.endDate,
                          ),
                        ),
                        const SpacerV(16),
                        Row(
                          children: [
                            Expanded(
                              child: TimeFilter(
                                onSelect: (value) => _onSetTimeStart(bloc, value),
                                initialValue: state.interval.startTime,
                                title: t.filters.timeFrom,
                              ),
                            ),
                            const SpacerH(10),
                            Expanded(
                              child: TimeFilter(
                                onSelect: (value) => _onSetTimeEnd(bloc, value),
                                initialValue: state.interval.endTime,
                                title: t.filters.timeTo,
                              ),
                            ),
                          ],
                        ),
                        const SpacerV(16),
                        Column(
                          spacing: 16,
                          children: [
                            for (final filter in state.filters)
                              SampleFilter(
                                filter: filter, 
                                onSelectSingle: (filterId, value) => 
                                  _onSetFilter(bloc, filterId, value: value),
                              ), 
                            const SpacerV(16),
                            if (state.exportIsPossible && exportEnabled)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: context.theme.colorScheme.secondaryContainer.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: AppText(
                                    text: t.filters.exportWarining,
                                    style: context.theme.textTheme.bodySmall,
                                    ellispis: false,
                                  ),
                                ),
                              ),
                            if (exportEnabled)
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ExportButton(
                                    exportType: ExportType.excel,
                                    disabled: state.exportIsPossible,
                                  ),
                                  const SpacerV(16),
                                  ExportButton(
                                    exportType: ExportType.csv,
                                    disabled: state.exportIsPossible,
                                  ),
                                ],
                              ),
                            const SpacerV(80),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 16,
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 4,
                      children: [
                        Expanded(
                          child: AppButton.activeColor(
                            title: t.common.accept,
                            onTap: () => _onAccept(bloc),
                          ),
                        ),
                        AppButton.icon(
                          onTap: () => _onReset(bloc),
                          padding: const EdgeInsets.all(10),
                          icon: Icon(
                            Icons.restart_alt_outlined,
                            color: context.theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ), 
            _ => const AppLoader(),
          },
        ),
      ),
    );
  }
}