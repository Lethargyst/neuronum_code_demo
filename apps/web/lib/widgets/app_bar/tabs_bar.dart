import 'package:flutter/material.dart';
import 'package:lvm_telephony_web/utils/extensions/build_context.dart';
import 'package:lvm_telephony_web/widgets/app_scroll/app_scroll_wrapper.dart';
import 'package:lvm_telephony_web/widgets/text/app_text.dart';

/// Моделька таба
final class TabItem {
  final String name;
  final VoidCallback onTap;
  final Widget? icon;
  /// Список с дополнительными действиями (название, коллбэк нажатия)
  final List<(String, VoidCallback)>? actions;

  const TabItem({
    required this.name,
    required this.onTap,
    this.icon,
    this.actions,
  });
}

/// Список табов
class TabsList extends StatefulWidget {
  final List<TabItem> tabs;
  final int initialIndex;

  const TabsList({
    required this.tabs,
    this.initialIndex = 0,
    super.key, 
  });

  @override
  State<TabsList> createState() => _TabsListState();
}

class _TabsListState extends State<TabsList> {
  late int _activeIndex;
  
  @override
  void initState() {
    _activeIndex = widget.initialIndex;
    super.initState();
  }

  void _onSelect(int index) {
    _activeIndex = index;
    setState(() {});
  }
  
  @override
  Widget build(BuildContext context) => AppScrollWrapper(
    direction: Axis.horizontal,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: widget.tabs.length,
      separatorBuilder: (context, __) => VerticalDivider(
        color: context.theme.colorScheme.primary,
        indent: 7,
        endIndent: 7,
        width: 10,
      ),
      itemBuilder: (_, index) => Listener( 
          onPointerDown: (_) => _onSelect(index),
          child: _Tab(
            item: widget.tabs[index],
            isActive: index == _activeIndex,
          ),
        ),
    ),
  );
}

class _Tab extends StatelessWidget {
  final TabItem item;
  final bool isActive;
  
  const _Tab({
    required this.item,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) => Material(
    borderRadius: _getBorderRadius(),
    child: InkWell(
      onTap: item.onTap,
      borderRadius: _getBorderRadius(),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 100),
        child: Ink(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: _getBorderRadius(),
            color: isActive ? context.theme.colorScheme.primary.withOpacity(0.3) : null,
          ),
          child: Center(
            child: AppText.bold(
              context: context, 
              text: item.name,
              color: isActive ? context.theme.colorScheme.primary : null,
            ),
          ),
        ),
      ),
    ),
  );

  BorderRadius _getBorderRadius() => const BorderRadius.only(
    topLeft: Radius.circular(8), 
    topRight: Radius.circular(8),
  );
}