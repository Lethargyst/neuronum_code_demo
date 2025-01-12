import 'package:common/bloc/dashboards_bloc/dashboards_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:common/gen/translations.g.dart';
import 'package:domain/entity/common/telephony_project.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lvm_telephony_web/widgets/app_bar/app_bar.dart';

import 'dashboards_screen_view.dart';

/// Экран графиков (дашбордов)
@RoutePage()
class DashboardsScreen extends StatelessWidget {
  const DashboardsScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: CustomAppBar.common(title: t.dashboards.dashboards),
    body: BlocProvider<DashboardsBloc>(
          create: (_) => GetIt.I<DashboardsBloc>()
            ..init(projectId: context.read<TelephonyProject>().id)
            ..add(GetDashboardsEvent()),
          child: const DashboardsScreenView(),
        ),
  );
}