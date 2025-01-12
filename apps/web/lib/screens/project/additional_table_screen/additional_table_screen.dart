import 'package:common/bloc/additional_table_bloc/additional_table_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'additional_table_screen_view.dart';

/// Экран доп таблицы звонков
@RoutePage()
class AdditionalTableScreen extends StatelessWidget {
  final String projectId;
  final String tableId;

  const AdditionalTableScreen({
    required this.projectId,
    required this.tableId,
    super.key,
  });

  @override
  Widget build(BuildContext context) => BlocProvider<AdditionalTableBloc>(
        create: (_) => GetIt.I<AdditionalTableBloc>()
          ..init(projectId: projectId, tableId: tableId)
          ..add(const InitialFetchEvent()),
        child: const AdditionalTableScreenView(),
      );
}