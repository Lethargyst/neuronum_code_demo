import 'package:common/bloc/sign_up_bloc/sign_up_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


part 'views/error_view.dart';
part 'views/loading_view.dart';
part 'views/success_view.dart';

class SignUpScreenView extends StatelessWidget {
  const SignUpScreenView({super.key});

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Scaffold(
      body: BlocBuilder<SignUpBloc, SignUpState>(
        builder: (_, state) => switch (state) {
          SuccessState() => const _SuccessView(),
          FailureState() => const _ErrorView(),
          LoadingState() => const _LoadingView(),
        },
      ),
    ),
  );
}
