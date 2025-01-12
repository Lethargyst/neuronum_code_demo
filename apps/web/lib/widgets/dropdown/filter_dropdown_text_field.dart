import 'package:core/typedefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lvm_telephony_web/utils/extensions/build_context.dart';
import 'package:lvm_telephony_web/widgets/text_fields/filter_text_field.dart';

/// Выпадающий список со строками
class FilterDropdownTextField extends StatefulWidget {
  /// Виджет, при нажатии по которому, открывается список 
  final Widget child;
  /// Значения списка для выбора
  final List<String> values;
  /// Коллбэе, вызывающийся при выборе значения списка
  final StringCallback? onSelectSingle;
  /// Коллбэе, вызывающийся при выборе значения списка
  final void Function(List<String>)? onSelectMultiple;
  /// Выбранное значение списка
  final String? selectedSingleValue;
  final String? initialValue;
  final List<String>? selectedMultipleValues;
  final BorderRadius? borderRadius;

  const FilterDropdownTextField({
    required this.child,
    required this.values,
    this.onSelectSingle,
    this.onSelectMultiple,
    this.selectedSingleValue,
    this.initialValue,
    this.selectedMultipleValues,
    this.borderRadius,
    super.key,
  });

  @override
  State<FilterDropdownTextField> createState() => _FilterDropdownTextFieldState();
}

class _FilterDropdownTextFieldState extends State<FilterDropdownTextField> {
  late List<String> _currentValues = widget.values; 
  final _inputValueNotifier = ValueNotifier<String>('');
  final  _activeIndexNotifier = ValueNotifier<int>(0);
  final _textEditingController = TextEditingController();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  void _removeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _openDropdown() {
    if (_overlayEntry != null) return;
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _onSelectSingle(String value) {
    widget.onSelectSingle?.call(value);
    _textEditingController.text = value;
    _overlayEntry?.remove();
    _overlayEntry = null;
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
              constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(context).height - offset.dy - 16,
              ),
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
                  elevation: 4,
                  color: context.theme.colorScheme.tertiary,
                  child: ValueListenableBuilder(
                    valueListenable: _inputValueNotifier,
                    builder: (context, inputText, _) => ValueListenableBuilder(
                      valueListenable: _activeIndexNotifier,
                      builder: (context, activeIndex, _) => ListView(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        children: [
                          for (var itemIndex = 0; itemIndex < _currentValues.length; ++itemIndex)
                            ListTile(
                              tileColor: 
                                widget.selectedSingleValue == _currentValues[itemIndex] || 
                                activeIndex == itemIndex
                                  ? context.theme.colorScheme.primary.withOpacity(0.2)
                                  : null,
                              hoverColor: context.theme.colorScheme.primary.withOpacity(0.2),
                              title: _SearchItemText(
                                text: _currentValues[itemIndex], 
                                inputText: inputText,
                              ),
                              onTap: () => _onSelectSingle(_currentValues[itemIndex]),
                            ),
                        ],
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

  int _comparator(String left, String right) {
    var a = left.toLowerCase();
    var b = right.toLowerCase();

    num aSearchStringIndex = a.indexOf(_inputValueNotifier.value);
    num bSearchStringIndex = b.indexOf(_inputValueNotifier.value);

    aSearchStringIndex = aSearchStringIndex == -1 ? double.infinity : aSearchStringIndex;
    bSearchStringIndex = bSearchStringIndex == -1 ? double.infinity : bSearchStringIndex; 

    if (aSearchStringIndex < bSearchStringIndex) {
      return -1;
    }
    if (aSearchStringIndex > bSearchStringIndex) {
      return 1;
    }

    return 0;
  }

  void _onEditing(String? value) {
    _currentValues = widget.values
      .where((e) => e.toLowerCase().contains(_inputValueNotifier.value))
      .toList();
    _currentValues.sort(_comparator);
    _inputValueNotifier.value = value ?? '';
    _activeIndexNotifier.value = 0;
    _openDropdown();
    widget.onSelectSingle?.call(value ?? '');
  }

  void _keyEventHandler(KeyEvent event) => switch (event.logicalKey) {
    LogicalKeyboardKey.arrowUp => _activeIndexNotifier.value = 
      _activeIndexNotifier.value > 0 
        ? _activeIndexNotifier.value - 1 
        : 0,
    LogicalKeyboardKey.arrowDown => _activeIndexNotifier.value = 
      _activeIndexNotifier.value < _currentValues.length - 1
        ? _activeIndexNotifier.value + 1 
        : _currentValues.length - 1,
    LogicalKeyboardKey.enter => _onSelectSingle(_currentValues[_activeIndexNotifier.value]),
    _ => null
  };

  @override
  void dispose() {
    _textEditingController.dispose();
    _activeIndexNotifier.dispose();
    _inputValueNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => CompositedTransformTarget(
      link: _layerLink,
      child: FilterTextField(
        initialValue: widget.initialValue,
        controller: _textEditingController,
        onEditing: _onEditing,
        onFocus: _openDropdown,
        onKeyEvent: _keyEventHandler,
      ),
    );
}

class _SearchItemText extends StatelessWidget {
  final String text;
  final String inputText;

  const _SearchItemText({
    required this.text,
    required this.inputText,
  });

  @override
  Widget build(BuildContext context) {
    final textLower = text.toLowerCase();
    final inputTextLower = inputText.toLowerCase();
    final suitable = inputText.length > 1 && textLower.contains(inputTextLower);

    if (!suitable && inputText.length > 1) {
      return const SizedBox.shrink();
    }

    if (suitable) {
      final entranceIndex = textLower.indexOf(inputTextLower);

      return RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: text.substring(0, entranceIndex),
              style: context.theme.textTheme.labelLarge,
            ),
            TextSpan(
              text: text.substring(entranceIndex, entranceIndex + inputText.length),
              style: context.theme.textTheme.labelLarge?.copyWith(
                color: context.theme.colorScheme.primary,
              ),
            ),
            TextSpan(
              text: text.substring(entranceIndex + inputText.length),
              style: context.theme.textTheme.labelLarge,
            ),
          ],
        ),
      );
    }
  
    return Text(
      text,
      style: context.theme.textTheme.labelLarge,
    );
  }
}
