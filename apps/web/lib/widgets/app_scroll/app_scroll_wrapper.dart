import 'package:flutter/material.dart';
import 'package:lvm_telephony_web/utils/extensions/build_context.dart';
import 'package:lvm_telephony_web/widgets/app_scroll/app_scrollbar.dart';

class AppScrollWrapper extends StatefulWidget {
  final Widget child;
  final ScrollController? controller;
  final VoidCallback? onPagination;
  /// Метод, вызываемый при обновлении страницы (если null - рефреша страницы нет)
  final Future<void> Function()? onRefresh;
  final Axis? direction;

  const AppScrollWrapper({
    required this.child,
    super.key,
    this.controller,
    this.onPagination,
    this.onRefresh,
    this.direction = Axis.vertical,
  });

  @override
  State<AppScrollWrapper> createState() => _AppScrollViewState();
}

class _AppScrollViewState extends State<AppScrollWrapper> {
  late final ScrollController controller;

  /// Создан ли контроллер внутри этого виджета
  late final bool isLocalController;

  @override
  void initState() {
    controller = widget.controller ?? ScrollController();
    if (widget.onPagination != null) {
      controller.addListener(_scrollListener);
    }
    isLocalController = widget.controller == null;
    super.initState();
  }

  void _scrollListener() {
    if (controller.position.pixels > controller.position.maxScrollExtent - 100) {
      widget.onPagination!.call();
    }
  }

  @override
  void dispose() {
    if (isLocalController) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.onRefresh != null) {
      return LayoutBuilder(
        builder: (context, constraints) => RefreshIndicator(
          displacement: 20,
          color: context.theme.colorScheme.primary,
          onRefresh: widget.onRefresh!,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
              maxWidth: constraints.maxWidth,
            ),
            child: AppScroll(
              child: widget.child, 
              controller: controller,
              direction: widget.direction,
            ),
          ),
        ),
      );
    }

    return AppScroll(
      child: widget.child, 
      controller: controller,
      direction: widget.direction,
    );
  }
}
