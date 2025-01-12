import 'package:common/bloc/sign_in_bloc/sign_in_bloc.dart';
import 'package:common/gen/translations.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lvm_telephony_web/core/service/router/router.dart';
import 'package:lvm_telephony_web/theme/app_colors.dart';
import 'package:lvm_telephony_web/utils/extensions/build_context.dart';
import 'package:lvm_telephony_web/widgets/app_flushbar/app_flushbar.dart';
import 'package:lvm_telephony_web/widgets/buttons/app_button.dart';
import 'package:lvm_telephony_web/widgets/common/spacers.dart';
import 'package:lvm_telephony_web/widgets/text_fields/app_text_field.dart';

class SignInScreenView extends StatefulWidget {
  const SignInScreenView({super.key});

  @override
  State<SignInScreenView> createState() => _SignInScreenViewState();
}

class _SignInScreenViewState extends State<SignInScreenView> {
  void _onEditLogin(String value) => context.read<SignInBloc>().add(EditLoginEvent(value));

  void _onEditPassword(String value) => context.read<SignInBloc>().add(EditPasswordEvent(value));

  void _onLogin() => context.read<SignInBloc>().add(const LoginEvent());

  Future<void> _onFailure(String message) => showFlushbar(context, message: message);

  Future<void> _onSuccess() async => context.router.navigate(const HomeRoute());

  @override
  Widget build(BuildContext context) => BlocListener<SignInBloc, SignInState>(
        listener: (context, state) async => switch (state) {
          SuccessState() => _onSuccess(),
          FailureState() => _onFailure(state.message),
          _ => null
        },
        child: LayoutBuilder(
          builder: (context, constraints) => Center(
            child: Container(
              width: constraints.minWidth / 2,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.white,
                boxShadow: [
                  const BoxShadow(
                    color: Color(0x26000000),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  StreamBuilder<String?>(
                    stream: context.read<SignInBloc>().emailValidationError,
                    builder: (context, snapshot) => AppTextField(
                      labelText: t.auth.login,
                      hintText: t.auth.enterEmail,
                      inputAction: TextInputAction.next,
                      errorText: snapshot.data,
                      denySpaces: true,
                      autoFillHints: [AutofillHints.username],
                      onChangeValue: _onEditLogin,
                    ),
                  ),
                  const SpacerV(20),
                  StreamBuilder<String?>(
                    stream: context.read<SignInBloc>().passwordValidationError,
                    builder: (context, snapshot) => AppTextField(
                      labelText: t.auth.password,
                      hintText: t.auth.enterPassword,
                      isPassword: true,
                      inputAction: TextInputAction.done,
                      errorText: snapshot.data,
                      denySpaces: true,
                      autoFillHints: [AutofillHints.password],
                      onChangeValue: _onEditPassword,
                    ),
                  ),
                  const SpacerV(40),
                  BlocBuilder<SignInBloc, SignInState>(
                    builder: (context, state) => AppButton.activeColor(
                      title: t.auth.signIn,
                      onTap: _onLogin,
                      isLoading: state is LoadingState,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
