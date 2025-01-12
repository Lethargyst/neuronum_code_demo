import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lvm_telephony_web/utils/extensions/build_context.dart';

class AppScroll extends StatefulWidget {
  final Widget child;
  final ScrollController? controller;
  final Axis? direction;

  const AppScroll({ 
    required this.child,
    this.controller,
    this.direction,
    super.key, 
  });

  @override
  State<AppScroll> createState() => _AppScrollState();
}

class _AppScrollState extends State<AppScroll> {
  late ScrollController _controller;
  bool _isLocalController = false;

  @override
  void initState() {
    _controller = widget.controller ?? ScrollController();
    _isLocalController = widget.controller == null;
    super.initState();
  }

  @override
  void dispose() {
    if (_isLocalController) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AppScrollBar(
    controller: _controller,
    child: Listener(
      onPointerSignal: (event) {
        if (event is PointerScrollEvent) {
          final offset = event.scrollDelta.dy;
          
          var y = _controller.offset + offset; 
          if (y > _controller.position.maxScrollExtent) {
            y = _controller.position.maxScrollExtent;
          } else if (y < 0) {
            y = 0;
          }
          
          _controller.jumpTo(y);
        }
      },
      child: SingleChildScrollView(
        scrollDirection: widget.direction ?? Axis.vertical,
        physics: const AlwaysScrollableScrollPhysics(),
        controller: _controller,
        child: widget.child,
      ),
    ),
  );
}

class AppScrollBar extends StatelessWidget {
  final Widget child;
  final ScrollController controller;
  final ScrollbarOrientation? orientation;

  const AppScrollBar({ 
    required this.child,
    required this.controller,
    this.orientation,
    super.key, 
  });

  @override
  Widget build(BuildContext context) => ScrollConfiguration(
    behavior: const ScrollBehavior().copyWith(
      scrollbars: true,
      dragDevices: {
        PointerDeviceKind.touch, 
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.unknown,
      },
    ),
    child: ScrollbarTheme(
      data: ScrollbarTheme.of(context).copyWith(
        thumbColor: WidgetStatePropertyAll(context.theme.colorScheme.primary),
      ),
      child: Scrollbar(
        controller: controller,
        thickness: 6,
        interactive: true,
        child: child,
        scrollbarOrientation: orientation,
      ),
    ),
  );
}