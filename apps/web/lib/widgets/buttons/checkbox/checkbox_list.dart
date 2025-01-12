import 'package:common/gen/translations.g.dart';
import 'package:flutter/material.dart';
import 'package:lvm_telephony_web/utils/extensions/build_context.dart';
import 'package:lvm_telephony_web/widgets/buttons/app_button.dart';
import 'package:lvm_telephony_web/widgets/buttons/checkbox/checkbox_row.dart';
import 'package:lvm_telephony_web/widgets/common/spacers.dart';

class CheckboxList extends StatefulWidget {
  final List<String> values;
  final void Function(List<String>) onSelect;
  final List<String>? selectedValues;
  final VoidCallback? onClear;
  
  const CheckboxList({ 
    required this.values,
    required this.onSelect,
    this.selectedValues,
    this.onClear,
    super.key, 
  });

  @override
  State<CheckboxList> createState() => _CheckboxListState();
}

class _CheckboxListState extends State<CheckboxList> {
  late final _selectedValues = widget.selectedValues ?? [];

  void _onToggle(String value, bool isSelected) {
    if (isSelected) {
      _selectedValues.add(value);
      return;
    }
    _selectedValues.remove(value);
  }

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
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
    child: Column(
      children: [
        Expanded(
          child: ListView.separated(
            itemCount: widget.values.length,
            separatorBuilder: (_, __) => const SpacerV(10), 
            itemBuilder: (_, index) => CheckboxRow(
              title: widget.values[index],
              value: _selectedValues.contains(widget.values[index]),
              onSelect: (isSelected) => _onToggle(widget.values[index], isSelected),
            ), 
          ),
        ),
        const SpacerV(16),
        AppButton.activeColor(
          title: t.common.accept,
          onTap: () => widget.onSelect(_selectedValues),
        ),
      ],
    ),
  );
}