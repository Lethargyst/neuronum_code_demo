import 'package:common/gen/translations.g.dart';
import 'package:core/typedefs.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:domain/utils/extensions/date_time_extension.dart';
import 'package:flutter/material.dart';
import 'package:lvm_telephony_web/utils/extensions/build_context.dart';
import 'package:lvm_telephony_web/widgets/text/app_text.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

/// Фильтр даты
class DateFilter extends StatefulWidget {
  final void Function(DateTime start, DateTime end) onSelect;
  final bool labelInsideField;
  final DateTimeRange? initialValue;
  final BoolCallback? onToggleFilter;

  const DateFilter({ 
    required this.onSelect,
    this.labelInsideField = false,
    this.initialValue,
    this.onToggleFilter,
    super.key, 
  });

  @override
  State<DateFilter> createState() => _DateFilterState();
}

class _DateFilterState extends State<DateFilter> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  DateTimeRange? _selectedValue;

  void _toggleDropdown() {
    if (_overlayEntry == null) {
      _openDropdown();
      return;
    }
    _removeDropdown();
  }

  void _removeDropdown() {
    widget.onToggleFilter?.call(false);
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _openDropdown() {
    widget.onToggleFilter?.call(true);
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _onSelect(DateTimeRange value) {
    _selectedValue = value;
    widget.onSelect.call(value.start, value.end);

    // _overlayEntry?.remove();
    // _overlayEntry = null;
    setState(() {});
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject()! as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => PointerInterceptor(
        child: Positioned(
          left: offset.dx + size.width,
          top: offset.dy,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(size.width + 10, 0),
            child: TapRegion(
              onTapOutside: (_) => _removeDropdown(),
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: context.theme.colorScheme.tertiary,
                  boxShadow: [
                    BoxShadow(
                      color: context.theme.colorScheme.onSurfaceVariant,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Material(
                    color: context.theme.colorScheme.tertiary,
                    child: PointerInterceptor(
                      child: RangeDatePicker(
                        centerLeadingDate: true,
                        minDate: DateTime(2020),
                        maxDate: DateTime.now(),
                        selectedRange: _selectedValue,
                        onRangeSelected: _onSelect,
                        slidersColor: context.theme.colorScheme.primary,
                        splashColor: context.theme.colorScheme.primary.withOpacity(0.2),
                        selectedCellsDecoration: BoxDecoration(
                          color: context.theme.colorScheme.primaryFixed,
                        ),
                        singleSelectedCellDecoration: BoxDecoration(
                          color: context.theme.colorScheme.primaryFixed,
                          shape: BoxShape.circle,
                        ),
                        currentDateDecoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        splashRadius: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => PointerInterceptor(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!widget.labelInsideField)
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: AppText.bold(context: context, text: t.common.date),
          ),
        CompositedTransformTarget(
          link: _layerLink,
          child: Material(
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: _toggleDropdown,
              child: LayoutBuilder(
                builder: (context, constraints) => Ink(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: context.theme.colorScheme.surface,
                  ),
                  width: constraints.maxWidth,
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: AppText.bold(
                    context: context, 
                    textAlign: TextAlign.center,
                    text: _getTextValue(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );

  String _getTextValue() {
    if (_selectedValue != null) {
      return '${_selectedValue?.start.formattedDateString ?? ''} - ${_selectedValue?.end.formattedDateString ?? ''}'; 
    }

    if (widget.initialValue != null) {
      return '${widget.initialValue?.start.formattedDateString ?? ''} - ${widget.initialValue?.end.formattedDateString ?? ''}';
    }

    if (widget.labelInsideField) {
      return t.common.date;
    } 

    return '';
  }
}