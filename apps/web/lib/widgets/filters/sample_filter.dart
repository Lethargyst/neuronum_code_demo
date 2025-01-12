import 'package:domain/entity/common/filter.dart';
import 'package:flutter/material.dart';
import 'package:lvm_telephony_web/gen/assets.gen.dart';
import 'package:lvm_telephony_web/utils/extensions/build_context.dart';
import 'package:lvm_telephony_web/widgets/common/spacers.dart';
import 'package:lvm_telephony_web/widgets/dropdown/filter_dropdown_text_field.dart';
import 'package:lvm_telephony_web/widgets/text/app_text.dart';
import 'package:lvm_telephony_web/widgets/text_fields/filter_text_field.dart';

/// Виджет типового фильтра
class SampleFilter extends StatefulWidget {
  /// Фильтр
  final FilterEntity filter;

  final void Function(String filterId, String? value)? onSelectSingle;

  const SampleFilter({
    required this.filter,
    this.onSelectSingle,
    super.key,
  });

  @override
  State<SampleFilter> createState() => _SampleFilterState();
}

class _SampleFilterState extends State<SampleFilter> {
  String? _selectedSingleValue;
  List<String>? _selectedMultipleValues;

  void _onSelectSingle(String? value) {
    widget.onSelectSingle?.call(widget.filter.id, value);
    _selectedSingleValue = value;
    setState(() {});
  }

  void _onTextEditing(String? text) {
    widget.onSelectSingle?.call(widget.filter.id, text);
    _selectedSingleValue = text;
  }

  void _onClear() {
    _onSelectSingle(null);
  }

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      AppText.bold(context: context, text: widget.filter.name ?? ''),
      const SpacerV(5),
      Builder(
        builder: (context) {
          if (widget.filter.options == null) {
            return FilterTextField(
              initialValue: widget.filter.value,
              onEditing: _onTextEditing,
            );
          }
          
          return Material(
            borderRadius:  BorderRadius.circular(8),
            child: FilterDropdownTextField(
              values: widget.filter.options?.options ?? [],
              initialValue: widget.filter.value,
              selectedSingleValue: _selectedSingleValue,
              selectedMultipleValues: _selectedMultipleValues,
              onSelectSingle: _onSelectSingle,
              borderRadius:  BorderRadius.circular(8),
              child: LayoutBuilder(
                builder: (context, constraints) => Ink(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: context.theme.colorScheme.surface,
                  ),
                  width: constraints.maxWidth,
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: AppText.bold(
                          context: context, 
                          text: _selectedSingleValue ?? '',
                        ),
                      ),
          
                      if (_selectedSingleValue != null)
                        InkWell(
                          onTap: _onClear,
                          child: Assets.icons.calls.cancel.svg(),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    ],
  );
}
