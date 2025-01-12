import 'package:auto_route/auto_route.dart';
import 'package:domain/entity/common/telephony_project.dart';
import 'package:flutter/material.dart';
import 'package:lvm_telephony_web/core/service/router/guards/auth_guard.dart';
import 'package:lvm_telephony_web/screens/auth/auth_screen.dart';
import 'package:lvm_telephony_web/screens/auth/sign_in_screen/sign_in_screen.dart';
import 'package:lvm_telephony_web/screens/auth/sign_up_screen/sign_up_screen.dart';
import 'package:lvm_telephony_web/screens/onlyoffice_screen/onlyoffice_screen.dart';
import 'package:lvm_telephony_web/screens/project/calls_screen/calls_screen.dart';
import 'package:lvm_telephony_web/screens/project/calls_screen/routing_screen.dart';
import 'package:lvm_telephony_web/screens/project/dashboards_screen/dashboards_screen.dart';
import 'package:lvm_telephony_web/screens/home_screen.dart';
import 'package:lvm_telephony_web/screens/project/additional_table_screen/additional_table_screen.dart';
import 'package:lvm_telephony_web/screens/project/project_screen.dart';
import 'package:lvm_telephony_web/screens/root_screen.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class RouterWebConfig extends _$RouterWebConfig {
  AutoRoute _getPlatformRoute({
    required PageInfo<dynamic> page,
    String? path,
    bool initial = false,
    List<AutoRoute>? children,
    List<AutoRouteGuard> guards = const [],
  }) => CustomRoute(
    page: page,
    path: path,
    initial: initial,
    children: children,
    guards: guards,
    durationInMilliseconds: 200,
    reverseDurationInMilliseconds: 200,
    transitionsBuilder: (_, animation, __, child) {
      final transitionAnim = Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        ),
      );
      return SlideTransition(position: transitionAnim, child: child);
    },
  );

  @override
  List<AutoRoute> get routes => [
    _getPlatformRoute(
      page: RootRoute.page,
      path: "/",
      children: [
        _getPlatformRoute(
          page: HomeRoute.page,
          path: "home",
          initial: true,
          guards: [const AuthGuard()],
          children: [
            _getPlatformRoute(
              page: ProjectRoute.page,
              path: "project",
              children: [
                _getPlatformRoute(
                  page: CallsRoutingRoute.page,
                  initial: true,
                  path: "calls_routing",
                  children: [
                    _getPlatformRoute(
                      page: CallsRoute.page,
                      path: "calls",
                    ),
                    _getPlatformRoute(
                      page: AdditionalTableRoute.page,
                      path: "calls_table",
                    ),
                  ],
                ),
                _getPlatformRoute(
                  page: DashboardsRoute.page,
                  path: "dashboards",
                ),
                _getPlatformRoute(
                  page: OnlyofficeRoute.page,
                  path: "onlyoffice",
                ),
              ],
            ),
          ],
        ),
        _getPlatformRoute(
          page: AuthRoute.page,
          path: "auth",
          children: [
            _getPlatformRoute(
              page: SignInRoute.page,
              path: "sign_in",
              initial: true,
            ),
            _getPlatformRoute(
              page: SignUpRoute.page,
              path: "sign_up",
            ),
          ],
        ),
      ],
    ),
  ];
}
