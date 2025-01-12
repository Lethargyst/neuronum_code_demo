import 'package:auto_route/auto_route.dart';
import 'package:core/typedefs.dart';
import 'package:domain/entity/common/telephony_project.dart';
import 'package:flutter/material.dart';
import 'package:lvm_telephony_web/gen/translations.g.dart';
import 'package:lvm_telephony_web/screens/project/project_screen.dart';
import 'package:lvm_telephony_web/utils/extensions/build_context.dart';
import 'package:lvm_telephony_web/widgets/app_bar/menu.dart';
import 'package:lvm_telephony_web/widgets/app_bar/tabs_bar.dart';
import 'package:lvm_telephony_web/widgets/common/spacers.dart';
import 'package:lvm_telephony_web/widgets/filters/date_filter.dart';
import 'package:lvm_telephony_web/widgets/text/app_text.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

abstract class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar({ super.key });

  @override
  Size get preferredSize => const Size.fromHeight(40);

  factory CustomAppBar.project({
    required TelephonyProject project,
    required TabsRouter tabsRouter,
  })
    => _ProjectAppBar(
      project: project,
      tabsRouter: tabsRouter,
    );

  factory CustomAppBar.common({required String title})
    => _CommonAppBar(title: title,);

  factory CustomAppBar.onlyoffice({
    void Function(DateTime start, DateTime end)? onDateRangePicked,
    BoolCallback? onPreventHtmlGestures,
  }) 
    => _OnlyOfficeAppBar(
      onDateRangePicked: onDateRangePicked,
      onToggle: onPreventHtmlGestures,
    );
}

/// Эп бар для страницы [ProjectScreen]
final class _ProjectAppBar extends CustomAppBar {
  final TelephonyProject project;
  final TabsRouter tabsRouter;
  
  _ProjectAppBar({
    required this.project,
    required this.tabsRouter,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.only(left: 16, right: 16),
    decoration: BoxDecoration( 
      color: context.theme.colorScheme.tertiary,
      boxShadow: [
        BoxShadow(
          color: context.theme.colorScheme.tertiaryContainer.withOpacity(0.5),
          blurRadius: 5,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: TabsList(
              tabs: [
                TabItem(
                  name: t.calls.calls, 
                  onTap: () => tabsRouter.setActiveIndex(0),
                ),
            
                for (var i = 1; i <= project.callsTablesIds.length; ++i)
                  TabItem(
                    name: t.project.table(index: i),
                    onTap: () => tabsRouter.setActiveIndex(i),
                  ),
              ],
            ),
          ),
        ),
        const MenuDropdown(),
      ],
    ),
  );
}

final class _CommonAppBar extends CustomAppBar {
  final String title;
  
  _CommonAppBar({
    required this.title,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.only(left: 16, right: 16),
    decoration: BoxDecoration( 
      color: context.theme.colorScheme.tertiary,
      boxShadow: [
        BoxShadow(
          color: context.theme.colorScheme.tertiaryContainer.withOpacity(0.5),
          blurRadius: 5,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText.large(context: context, text: title),
        const MenuDropdown(),
      ],
    ),
  );
}

final class _OnlyOfficeAppBar extends CustomAppBar {
  final void Function(DateTime start, DateTime end)? onDateRangePicked;
  final BoolCallback? onToggle;
  
  _OnlyOfficeAppBar({
    this.onDateRangePicked,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) => PointerInterceptor(
    child: Container(
      padding: const EdgeInsets.only(left: 16, right: 16),
      decoration: BoxDecoration( 
        color: context.theme.colorScheme.tertiary,
        boxShadow: [
          BoxShadow(
            color: context.theme.colorScheme.tertiaryContainer.withOpacity(0.5),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          AppText.large(context: context, text: t.dashboards.reports),
          const SpacerH(32),
          SizedBox(
            width: 200,
            child: DateFilter(
              labelInsideField: true,
              onSelect: (start, end) => onDateRangePicked?.call(start, end),
              onToggleFilter: (value) => onToggle?.call(value),
            ),
          ),
          const Spacer(),
          MenuDropdown(
            onToggle: (value) => onToggle?.call(value),
          ),
        ],
      ),
    ),
  );
}