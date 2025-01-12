import 'package:common/bloc/sign_in_bloc/sign_in_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'sign_in_screen_view.dart';

/// Описание экрана
@RoutePage()
class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider<SignInBloc>(
        create: (_) => GetIt.I<SignInBloc>(),
        child: const SignInScreenView(),
      );
}