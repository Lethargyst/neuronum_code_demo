import 'package:common/bloc/additional_table_bloc/additional_table_bloc.dart';
import 'package:common/gen/translations.g.dart';
import 'package:domain/entity/common/filter.dart';
import 'package:domain/entity/response/table_call.dart';
import 'package:domain/utils/extensions/date_time_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lvm_telephony_web/gen/assets.gen.dart';
import 'package:lvm_telephony_web/theme/app_colors.dart';
import 'package:lvm_telephony_web/utils/extensions/build_context.dart';
import 'package:lvm_telephony_web/widgets/app_scroll/app_scroll_wrapper.dart';
import 'package:lvm_telephony_web/widgets/buttons/copy_button.dart';
import 'package:pluto_grid/pluto_grid.dart';

part 'data_cell_child.dart';
part 'date_time_cell_child.dart';

class CallsTable extends StatefulWidget {
  const CallsTable({super.key});

  @override
  State<CallsTable> createState() => _CallsTableState();
}

class _CallsTableState extends State<CallsTable> {
  Future<PlutoLazyPaginationResponse> _fetch(PlutoLazyPaginationRequest request) async {
    final calls = await context.read<AdditionalTableBloc>().getCalls(request.page);

    // TODO: Добавить количество страниц
    return PlutoLazyPaginationResponse(
      totalPage: 10, 
      rows: _getDataRows(calls),
    );
  }

  List<PlutoColumn> _getDataColumns(List<Section> columns) => [
    PlutoColumn(
      title: t.calls.phoneNumber, 
      field: 'phoneNumber', 
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: t.calls.dateTime, 
      field: 'dateTime', 
      type: PlutoColumnType.text(),
      renderer: (rendererContext) => 
        _DateTimeCellChild(dateTime: rendererContext.cell.value as DateTime),
    ),
    PlutoColumn(
      title: t.calls.callType, 
      field: 'callType',
      type: PlutoColumnType.text(),
      renderer: (rendererContext) => rendererContext.cell.value as bool 
        ? Assets.icons.common.incomingCall.svg(
          colorFilter: const ColorFilter.mode(AppColors.green, BlendMode.srcIn), 
        )
        : Assets.icons.common.outgoingCall.svg(
          colorFilter: const ColorFilter.mode(AppColors.blue, BlendMode.srcIn), 
        ),
    ),

    for (final column in columns)
      PlutoColumn(
        title: column.name ?? '',
        field: column.id,
        type: PlutoColumnType.text(),
        renderer: (rendererContext) => _DataCellTextChild(rendererContext.cell.value as String),
      ),
  ];

  List<PlutoRow> _getDataRows(List<TableCall> calls) => [
    for (final call in calls)
      PlutoRow(
        cells: _getDataCells(call),
      ),
  ];

  Map<String, PlutoCell> _getDataCells(TableCall call) => {
    'phoneNumber': PlutoCell(value: call.phoneNumber),
    'dateTime': PlutoCell(value: call.dateTime),
    'callType': PlutoCell(value: call.isIncoming),

    ...{
      for (final prop in call.properties)
       prop.key: PlutoCell(value: prop.value),    
    },
  };

  @override
  Widget build(BuildContext context) => BlocBuilder<AdditionalTableBloc, AdditionalTableState>(
    builder: (_, state) {
      final curState = state as SuccessState;
      return DecoratedBox(
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
        child: PlutoGrid(
          configuration: PlutoGridConfiguration(
            localeText: const PlutoGridLocaleText.russian(),
            columnSize: const PlutoGridColumnSizeConfig(
              autoSizeMode: PlutoAutoSizeMode.scale,
            ),
            scrollbar: PlutoGridScrollbarConfig(
              scrollBarColor: context.theme.colorScheme.primary,
              scrollbarThickness: 6,
            ),
            style: PlutoGridStyleConfig(
              gridBorderRadius: BorderRadius.circular(8),
              enableGridBorderShadow: true,
              evenRowColor: context.theme.colorScheme.tertiary,
              oddRowColor: context.theme.colorScheme.surface,
              activatedColor: context.theme.colorScheme.primaryFixed.withOpacity(0.3),
              cellTextStyle: context.theme.textTheme.bodyMedium!,
              columnTextStyle: context.theme.textTheme.labelLarge!,
              gridBorderColor: Colors.transparent,
              enableColumnBorderHorizontal: false,
            ),
          ),
          mode: PlutoGridMode.readOnly,
          columns: _getDataColumns(curState.columns), 
          rows: _getDataRows(curState.firstPageItems),
          createFooter: (stateManager) => PlutoLazyPagination(
            initialPage: 0,
            fetch: _fetch, 
            fetchWithFiltering: false,
            fetchWithSorting: false,
            stateManager: stateManager,
          ),
        ),
      );
    },
  );
}