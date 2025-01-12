import 'package:common/bloc/{{screen_name.snakeCase()}}_bloc/{{screen_name.snakeCase()}}_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '{{screen_name.snakeCase()}}_screen_view.dart';

/// Описание экрана
@RoutePage()
class {{screen_name.pascalCase()}}Screen extends StatelessWidget {
  const {{screen_name.pascalCase()}}Screen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider<{{screen_name.pascalCase()}}Bloc>(
        create: (_) => GetIt.I<{{screen_name.pascalCase()}}Bloc>(),
        child: const {{screen_name.pascalCase()}}ScreenView(),
      );
}