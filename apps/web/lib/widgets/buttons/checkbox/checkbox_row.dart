import 'package:core/typedefs.dart';
import 'package:flutter/material.dart';
import 'package:lvm_telephony_web/widgets/buttons/checkbox/checkbox.dart';
import 'package:lvm_telephony_web/widgets/common/spacers.dart';
import 'package:lvm_telephony_web/widgets/text/app_text.dart';

class CheckboxRow extends StatefulWidget {
  final String title;
  final BoolCallback? onSelect;
  final EdgeInsetsGeometry? padding;
  final bool? value;

  const CheckboxRow({
    required this.title,
    this.value = false,
    this.onSelect,
    this.padding,
    super.key,
  });

  @override
  State<CheckboxRow> createState() => _CheckboxRowState();
}

class _CheckboxRowState extends State<CheckboxRow> {
  late bool _value;

  @override
  void initState() {
    _value = widget.value ?? false;
    super.initState();
  }

  void _onToggle() {
    _value = !_value;
    widget.onSelect?.call(_value);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: _onToggle,
        child: Padding(
          padding: widget.padding ?? const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              AppCheckbox(
                initialValue: _value,
                ignorePointer: true,
              ),
              const SpacerH(20),
              Expanded(
                child: AppText.bold(
                  context: context,
                  text: widget.title,
                ),
              ),
            ],
          ),
        ),
      );
}
