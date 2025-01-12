import 'package:auto_route/auto_route.dart';
import 'package:domain/entity/common/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lvm_telephony_web/core/service/router/router.dart';
import 'package:lvm_telephony_web/utils/extensions/build_context.dart';


/// Главный экран
@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<User>();

    return SafeArea(
      child: AutoTabsScaffold(
        key: ValueKey(user.id),
        backgroundColor: context.theme.colorScheme.surface,
        homeIndex: 0,
        routes: [
          for (final project in user.projects)
            ProjectRoute(
              key: ValueKey(project.id),
              project: project,
            ),
        ],
      ),
    );
  }
}