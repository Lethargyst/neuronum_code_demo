import 'package:common/gen/translations.g.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:day_night_time_picker/lib/day_night_timepicker_android.dart';
import 'package:day_night_time_picker/lib/state/state_container.dart';
import 'package:domain/utils/extensions/date_time_extension.dart';
import 'package:flutter/material.dart';
import 'package:lvm_telephony_web/utils/extensions/build_context.dart';
import 'package:lvm_telephony_web/widgets/common/spacers.dart';
import 'package:lvm_telephony_web/widgets/text/app_text.dart';

/// Фильтр времени
class TimeFilter extends StatefulWidget {
  final void Function(DateTime value) onSelect;
  final DateTime initialValue;
  final String? title;

  const TimeFilter({ 
    required this.onSelect,
    required this.initialValue,
    this.title,
    super.key, 
  });

  @override
  State<TimeFilter> createState() => _TimeFilterState();
}

class _TimeFilterState extends State<TimeFilter> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  late DateTime _selectedValue;

  @override
  void initState() {
    _selectedValue = widget.initialValue;
    super.initState();
  }

  void _toggleDropdown() {
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

  void _onSelect(Time value) {
    final time = DateTimeX.time(value.hour, value.minute);

    _selectedValue = time;
    widget.onSelect.call(time);
    setState(() {});
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject()! as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
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
              height: 500,
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
                  child: TimeModelBinding(
                    initialTime: Time(hour: _selectedValue.hour, minute: _selectedValue.minute),
                    disableHour: false,
                    disableMinute: false,
                    minMinute: 0,
                    maxMinute: 59,
                    minHour: 0,
                    maxHour: 23,
                    displayHeader: true,
                    is24HrFormat: true,
                    onChange: _onSelect,
                    onCancel: _removeDropdown,
                    okText: t.common.accept,
                    cancelText: t.common.cancel,
                    child: const DayNightTimePickerAndroid(
                      sunrise: TimeOfDay(hour: 7, minute: 0), 
                      sunset: TimeOfDay(hour: 22, minute: 0), 
                      duskSpanInMinutes: 60,
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
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      AppText.bold(context: context, text: widget.title ?? t.common.time),
      const SpacerV(5),
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
                  text: _selectedValue.formattedTimeString,
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}