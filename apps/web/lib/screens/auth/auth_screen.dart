import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lvm_telephony_web/core/service/router/router.dart';

/// Описание экрана
@RoutePage()
class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) => const SafeArea(
    child: AutoTabsScaffold(
      homeIndex: 0,
      routes: [
        SignInRoute(),
        SignUpRoute(),
      ],
    ),
  );
}