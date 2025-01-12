import 'package:common/bloc/{{screen_name.snakeCase()}}_bloc/{{screen_name.snakeCase()}}_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


part 'views/error_view.dart';
part 'views/loading_view.dart';
part 'views/success_view.dart';

class {{screen_name.pascalCase()}}ScreenView extends StatelessWidget {
  const {{screen_name.pascalCase()}}ScreenView({super.key});

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Scaffold(
      body: BlocBuilder<{{screen_name.pascalCase()}}Bloc, {{screen_name.pascalCase()}}State>(
        builder: (_, state) => switch (state) {
          SuccessState() => const _SuccessView(),
          FailureState() => const _ErrorView(),
          LoadingState() => const _LoadingView(),
        },
      ),
    ),
  );
}
