import 'package:core/typedefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lvm_telephony_web/gen/assets.gen.dart';
import 'package:lvm_telephony_web/utils/extensions/build_context.dart';

class AppTextField extends StatefulWidget {
  final String? labelText;
  final double? size;
  final double? height;
  final TextAlign textAlign;
  final String? hintText;
  final Widget? suffixWidget;
  final Widget? prefixWidget;
  final VoidCallback? onSuffixTap;
  final StringCallback? onChangeValue;
  final VoidCallback? onTap;
  final VoidCallback? onEditingComplete;
  final VoidCallback? onSubmitted;
  final TextEditingController? controller;
  final bool isPassword;
  final bool isPhoneNumber;
  final bool showPassword;
  final BoolCallback? onPasswordVisible;
  final int maxLines;
  final FormFieldValidator<String>? validator;
  final int? maxCharacter;
  final String? errorText;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool isEnable;
  final TextInputAction? inputAction;
  final TextCapitalization textCapitalization;
  final bool autocorrect;
  final String? initialValue;
  final bool denySpaces;
  final List<String>? autoFillHints;

  const AppTextField({
    this.labelText,
    super.key,
    this.hintText,
    this.suffixWidget,
    this.prefixWidget,
    this.onSuffixTap,
    this.onChangeValue,
    this.onTap,
    this.onEditingComplete,
    this.onSubmitted,
    this.controller,
    this.isPassword = false,
    this.isPhoneNumber = false,
    this.showPassword = false,
    this.onPasswordVisible,
    this.maxLines = 1,
    this.validator,
    this.maxCharacter,
    this.errorText,
    this.keyboardType,
    this.focusNode,
    this.inputFormatters,
    this.isEnable = true,
    this.textCapitalization = TextCapitalization.none,
    this.autocorrect = true,
    this.inputAction,
    this.size,
    this.height,
    this.textAlign = TextAlign.start,
    this.initialValue,
    this.denySpaces = false,
    this.autoFillHints,
  }) : assert(
          !(size != null && height != null),
          'size и height не могут быть не null одновременно',
        );

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _isVisibly;
  late final FocusNode _focusNode;
  late final bool _isLocalFocusNode;
  late final TextEditingController _controller;
  late final bool _isLocalController;

  @override
  void initState() {
    _isVisibly = !(widget.isPassword && !widget.showPassword);
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_focusNodeListener);
    _isLocalFocusNode = widget.focusNode == null;
    _controller = widget.controller ?? TextEditingController();
    _isLocalController = widget.controller == null;
    _controller.text = widget.initialValue ?? '';
    super.initState();
  }

  void _focusNodeListener() {
    if (!_focusNode.hasFocus) widget.onEditingComplete?.call();
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant AppTextField oldWidget) {
    if (oldWidget.initialValue != widget.initialValue) {
      _controller.text = widget.initialValue ?? '';
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    if (_isLocalFocusNode) {
      _focusNode.dispose();
    }
    if (_isLocalController) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.labelText != null)
            Padding(
              padding: (widget.textAlign == TextAlign.center)
                  ? EdgeInsets.zero
                  : const EdgeInsets.only(left: 12, bottom: 8),
              child: Align(
                alignment: (widget.textAlign == TextAlign.center)
                    ? Alignment.center
                    : Alignment.centerLeft,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: widget.labelText,
                        style: context.theme.textTheme.bodyMedium?.copyWith(
                          color: widget.isEnable
                              ? context.theme.colorScheme.inversePrimary
                              : context.theme.colorScheme.tertiaryContainer.withOpacity(0.3),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Container(
            width: widget.size,
            height: widget.size ?? widget.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: context.theme.colorScheme.tertiary,
              boxShadow: [
                if (!_focusNode.hasFocus)
                  const BoxShadow(
                    color: Color.fromARGB(60, 0, 0, 0),
                    blurRadius: 5,
                  ),
                if (_focusNode.hasFocus)
                  BoxShadow(
                    color: context.theme.colorScheme.primaryContainer.withOpacity(0.5),
                    blurRadius: 5,
                  ),
              ],
            ),
            child: TextFormField(
              onTap: widget.onTap,
              autofillHints: widget.autoFillHints,
              controller: _controller,
              style: context.theme.textTheme.bodyMedium,
              maxLines: widget.maxLines,
              obscureText: !_isVisibly,
              onChanged: widget.onChangeValue,
              onEditingComplete: widget.onEditingComplete,
              validator: widget.validator,
              focusNode: _focusNode,
              keyboardType: widget.keyboardType,
              enabled: widget.isEnable,
              autocorrect: widget.autocorrect,
              textCapitalization: widget.textCapitalization,
              textInputAction: widget.inputAction,
              textAlign: widget.textAlign,
              inputFormatters: [
                LengthLimitingTextInputFormatter(widget.maxCharacter),
                if (widget.denySpaces) FilteringTextInputFormatter.deny(RegExp(r'\s')),
                if (widget.inputFormatters != null) ...widget.inputFormatters!,
              ],
              onTapOutside: (_) => _focusNode.unfocus(),
              onFieldSubmitted: (_) => widget.onSubmitted?.call(),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: context.theme.textTheme.bodyMedium?.copyWith(
                  color: context.theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
                ),
                contentPadding: widget.size != null
                    ? EdgeInsets.zero
                    : const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                enabledBorder: _defaultBorder(context),
                disabledBorder: _defaultBorder(context),
                focusedBorder: _defaultBorder(context),
                border: _defaultBorder(context),
                errorBorder: _defaultBorder(context),
                focusedErrorBorder: _defaultBorder(context),
                suffixIcon: widget.isPassword
                    ? GestureDetector(
                        onTap: () {
                          _isVisibly = !_isVisibly;
                          widget.onPasswordVisible?.call(_isVisibly);
                          setState(() {});
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: !_isVisibly
                              ? Assets.icons.common.visibility.svg()
                              : Assets.icons.common.visibilityOff.svg(),
                        ),
                      )
                    : widget.suffixWidget,
                prefixIcon: widget.prefixWidget,
              ),
            ),
          ),
        ],
      );

  InputBorder _defaultBorder(BuildContext contxt) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(
      color: Colors.transparent,
    ),
  );
}