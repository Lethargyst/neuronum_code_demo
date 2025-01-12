import 'package:common/bloc/export_bloc/export_bloc.dart';
import 'package:common/bloc/filters_bloc/filters_bloc.dart' as filters;
import 'package:common/gen/translations.g.dart';
import 'package:domain/entity/common/filter.dart';
import 'package:domain/entity/common/telephony_project.dart';
import 'package:domain/entity/time_range/time_range.dart';
import 'package:domain/usecase/export/export_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lvm_telephony_web/widgets/buttons/app_button.dart';

/// Кнопка экспорта таблицы
class ExportButton extends StatefulWidget {
  final ExportType exportType;
  final bool disabled;

  const ExportButton({ 
    required this.exportType, 
    this.disabled = false,
    super.key,
  });

  @override
  State<ExportButton> createState() => _ExportButtonState();
}

class _ExportButtonState extends State<ExportButton> {
  late ExportBloc _bloc;

  @override
  void initState() {
    _bloc = GetIt.I<ExportBloc>()..init(
      type: widget.exportType, 
      projectId: context.read<TelephonyProject>().id,
    );

    context.read<filters.FiltersBloc>().filtersNotifier.listen(_filtersListener);

    super.initState();
  }

  void _filtersListener((List<FilterEntity>, TimeRange) data) => 
    _bloc.add(UpdateFiltersEvent(filters: data.$1, timeRange: data.$2)); 

  void _onTap() => _bloc.add(const LoadEvent());

  @override
  Future<void> dispose() async {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocProvider<ExportBloc>.value(
    value: _bloc,
    child: BlocBuilder<ExportBloc, ExportState>(
      builder: (_, state) => LayoutBuilder(
        builder: (context, constraints) => AppButton(
          onTap: _onTap,
          title: t.common.export(exportType: widget.exportType.name),
          isLoading: state is LoadingState,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          width: constraints.maxWidth,
          disabled: widget.disabled,
        ),
      ),
    ),
  );
}