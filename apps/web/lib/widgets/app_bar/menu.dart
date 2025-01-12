import 'package:core/typedefs.dart';
import 'package:domain/storage/user_storage.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:lvm_telephony_web/core/service/router/router.dart';
import 'package:lvm_telephony_web/gen/assets.gen.dart';
import 'package:lvm_telephony_web/gen/translations.g.dart';
import 'package:lvm_telephony_web/theme/app_colors.dart';
import 'package:lvm_telephony_web/utils/extensions/build_context.dart';
import 'package:lvm_telephony_web/widgets/common/spacers.dart';
import 'package:lvm_telephony_web/widgets/text/app_text.dart';

class MenuDropdown extends StatelessWidget {
  final BoolCallback? onToggle;

  const MenuDropdown({
    this.onToggle,
    super.key,
  });

  Future<void> _onLogout() => GetIt.I<UserStorage>().setUser(null);

  Future<void> _toCalls(BuildContext context) async {
    if (context.router.current.route.name == CallsRoutingRoute.name) return;
    context.router.push(
      const CallsRoutingRoute(),
    );
  }

  Future<void> _toOnlyoffice(BuildContext context) async {
    if (context.router.current.route.name == OnlyofficeRoute.name) return;
    context.router.push(
      const OnlyofficeRoute(),
    );
  }

  @override
  Widget build(BuildContext context) => PopupMenuButton(
    onOpened: () => onToggle?.call(true),
    onCanceled: () => onToggle?.call(false),
    icon: Assets.icons.common.logo.svg(),
    itemBuilder: (_) => [
      PopupMenuItem<dynamic>(
        onTap: () async => _toCalls(context),
        child: _MenuItem(
          title: t.calls.calls, 
          icon: Icon(
            Icons.call, 
            color: context.theme.colorScheme.primary,
          ),
        ),
      ),
      PopupMenuItem<dynamic>(
        onTap: () async => _toOnlyoffice(context),
        child: _MenuItem(
          title: t.dashboards.reports, 
          icon: const Icon(
            Icons.bar_chart_rounded, 
            color: AppColors.green,
          ),
        ),
      ),
      PopupMenuItem<dynamic>(
        onTap: _onLogout,
        child: _MenuItem(
          title: t.common.logout, 
          icon: Icon(
            Icons.logout_rounded,
            color: context.theme.colorScheme.error,
            size: 25,
          ), 
        ),
      ),
    ],
  );
}

class _MenuItem extends StatelessWidget {
  final String title;
  final Widget icon;
  
  const _MenuItem({ 
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) => Row(
    children: [
      icon,
      const SpacerH(10),
      AppText.bold(
        context: context, 
        text: title,
      ),
    ],
  );
}