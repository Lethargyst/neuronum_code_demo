import 'package:flutter/material.dart';
import 'package:lvm_telephony_web/utils/extensions/build_context.dart';

class FilterTextField extends StatefulWidget {
  final String? initialValue;
  final TextEditingController? controller;
  final void Function(String?)? onEditingComplete;
  final void Function(String?)? onEditing;
  final VoidCallback? onFocus;
  final void Function(KeyEvent)? onKeyEvent;

  const FilterTextField({
    this.initialValue,
    this.controller,
    this.onEditingComplete,
    this.onEditing,
    this.onFocus,
    this.onKeyEvent,
    super.key, 
  });

  @override
  State<FilterTextField> createState() => _FilterTextFieldState();
}

class _FilterTextFieldState extends State<FilterTextField> {
  late final TextEditingController _controller;
  late final bool _isLocalController;
  final _focusNode = FocusNode();
  final _keyEventsFocusNode = FocusNode();
  String? _curValue;

  @override
  void initState() {
    _controller = widget.controller ?? TextEditingController();
    _controller.text = widget.initialValue ?? '';
    _isLocalController = widget.controller == null;
    
    _focusNode.addListener(_focusNodeListener);
    super.initState();
  }

  void _focusNodeListener() {
    if (_focusNode.hasFocus) {
      widget.onFocus?.call();
      return;
    }
    widget.onEditingComplete?.call(_curValue);
  }

  @override
  void dispose() {
    if (_isLocalController) {
      _controller.dispose();
    }
    _focusNode.dispose();
    _keyEventsFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => KeyboardListener(
    autofocus: true,
    focusNode: _keyEventsFocusNode,
    onKeyEvent: widget.onKeyEvent,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: context.theme.colorScheme.surface,
      ),
      child: TextFormField(
        onChanged: widget.onEditing,
        controller: _controller,
        focusNode: _focusNode,
        style: context.theme.textTheme.labelLarge,
        onTapOutside: (_) => _focusNode.unfocus(),
        decoration: InputDecoration(
          isDense: true,
          disabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
    ),
  );
}