import 'package:common/bloc/sign_up_bloc/sign_up_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'sign_up_screen_view.dart';

/// Описание экрана
@RoutePage()
class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider<SignUpBloc>(
        create: (_) => GetIt.I<SignUpBloc>(),
        child: const SignUpScreenView(),
      );
}