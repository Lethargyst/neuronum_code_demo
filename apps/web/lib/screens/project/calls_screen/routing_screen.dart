import 'package:auto_route/auto_route.dart';
import 'package:domain/entity/common/telephony_project.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lvm_telephony_web/core/service/router/router.dart';
import 'package:lvm_telephony_web/utils/extensions/build_context.dart';
import 'package:lvm_telephony_web/widgets/app_bar/app_bar.dart';

@RoutePage()
class CallsRoutingScreen extends StatelessWidget {
  const CallsRoutingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final project = context.read<TelephonyProject>();

    return SafeArea(
      child: AutoTabsScaffold(
        appBarBuilder: (_, tabsRouter) => CustomAppBar.project(
          project: project,
          tabsRouter: tabsRouter, 
        ),
        backgroundColor: context.theme.colorScheme.surface,
        routes: [
          CallsRoute(
            key: ValueKey(project.id),
            projectId: project.id,
          ),      

          for (final tableId in project.callsTablesIds)
            AdditionalTableRoute(
              key: ValueKey(tableId),
              projectId: project.id,
              tableId: tableId,
            ),
        ],
      ),
    );
  }
}