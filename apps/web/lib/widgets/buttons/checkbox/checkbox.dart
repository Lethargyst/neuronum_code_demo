import 'package:core/typedefs.dart';
import 'package:flutter/material.dart';
import 'package:lvm_telephony_web/utils/extensions/build_context.dart';

class AppCheckbox extends StatefulWidget {
  final bool initialValue;
  final bool disabled;
  final bool ignorePointer;
  final bool? hasError;
  final BoolCallback? onToggle;

  const AppCheckbox({
    this.hasError,
    this.disabled = false,
    this.initialValue = false,
    this.ignorePointer = false,
    this.onToggle,
    super.key,
  });

  @override
  State<AppCheckbox> createState() => _AppCheckboxState();
}

class _AppCheckboxState extends State<AppCheckbox> {
  late bool _isChecked = widget.initialValue;

  @override
  void didUpdateWidget(covariant AppCheckbox oldWidget) {
    _isChecked = widget.initialValue;
    super.didUpdateWidget(oldWidget);
  }

  void onCheck() {
    if (widget.disabled) return;

    _isChecked = !_isChecked;
    widget.onToggle?.call(_isChecked);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => IgnorePointer(
    ignoring: widget.ignorePointer,
    child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: onCheck,
          child: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: Checkbox(
                  onChanged: (_) => onCheck(),
                  fillColor: WidgetStateProperty.resolveWith(
                    (states) {
                      if (widget.disabled) {
                        return context.theme.colorScheme.outline.withOpacity(0.4);
                      }
                      if (states.contains(WidgetState.selected)) {
                        return context.theme.colorScheme.primaryFixed;
                      }
                      return Colors.transparent;
                    }
                  ),
                  checkColor: widget.disabled 
                    ? context.theme.colorScheme.outline
                    : context.theme.colorScheme.tertiary,
                  side: WidgetStateBorderSide.resolveWith(
                    (states) {
                      if (widget.disabled) {
                        return null;
                      }
                
                      if (states.contains(WidgetState.selected)) {
                        return BorderSide(
                          color: context.theme.colorScheme.primaryFixed,
                          strokeAlign: 5,
                        );
                      } else if (widget.hasError != null && widget.hasError!) {
                        return BorderSide(
                          color: context.theme.colorScheme.error,
                          strokeAlign: 5,
                        );
                      }
                      return BorderSide(
                        color: context.theme.colorScheme.primaryFixed,
                        strokeAlign: 5,
                      );
                    },
                  ),
                  value: _isChecked,
                  shape: ContinuousRectangleBorder(
                    side: const BorderSide(strokeAlign: 5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  visualDensity: VisualDensity.comfortable,
                ),
              ),
            ],
          ),
        ),
  );
}
