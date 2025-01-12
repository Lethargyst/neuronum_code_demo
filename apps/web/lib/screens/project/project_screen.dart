import 'package:auto_route/auto_route.dart';
import 'package:domain/entity/common/telephony_project.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Экран проекта [TelephonyProject]
@RoutePage()
class ProjectScreen extends StatelessWidget {
  final TelephonyProject project;
  
  const ProjectScreen({
    required this.project,
    super.key,
  });

  @override
  Widget build(BuildContext context) => SafeArea(
      child: Provider<TelephonyProject>.value(
        key: ValueKey(project.id),
        value: project,
        child: const AutoRouter(),
      ),
    );
}