import 'package:flutter/material.dart';
import 'package:lvm_telephony_web/utils/extensions/build_context.dart';
import 'package:lvm_telephony_web/widgets/text/app_text.dart';

/// Оверлей с описанием при наведении курсора
class DescriptionOverlayWrapper extends StatefulWidget {
  final Widget child;
  final String? description;

  const DescriptionOverlayWrapper({
    required this.child,
    this.description,
    super.key,
  });

  @override
  State<DescriptionOverlayWrapper> createState() => _DescriptionOverlayWrapperState();
}

class _DescriptionOverlayWrapperState extends State<DescriptionOverlayWrapper> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  void _toggleDropdown() {
    if (widget.description == null) return;
    if (_overlayEntry == null) {
      _openDropdown();
      return;
    }
    _removeDropdown();
  }

  void _removeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _openDropdown() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject()! as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx ,
        top: offset.dy + size.height,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: context.theme.colorScheme.tertiaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: AppText.primary(context: context, text: widget.description!),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => CompositedTransformTarget(
      link: _layerLink,
      child: MouseRegion(
        onHover: (_) => _toggleDropdown,
        opaque: false,
        hitTestBehavior: HitTestBehavior.opaque,
        child: widget.child,
      ),
    );
}