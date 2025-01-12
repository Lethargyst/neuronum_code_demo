import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lvm_telephony_web/gen/translations.g.dart';
import 'package:lvm_telephony_web/utils/extensions/build_context.dart';
import 'package:lvm_telephony_web/widgets/buttons/app_button.dart';

class CopyButton extends StatefulWidget {
  final String copyText;
  final String? title;
  
  const CopyButton({ 
    required this.copyText,
    this.title, 
    super.key, 
  });

  @override
  State<CopyButton> createState() => _CopyButtonState();
}

class _CopyButtonState extends State<CopyButton> {
  bool _isCopied = false;

  Future<void> _onTap() async {
    await Clipboard.setData(ClipboardData(text: widget.copyText));
    _isCopied = true;
    setState(() {});
    await Future<void>.delayed(const Duration(seconds: 2));
    _isCopied = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => Builder(
    builder: (context) {
      if (_isCopied) {
        return AppButton(
          onTap: () {},
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          icon: const Icon(
            Icons.check,
            color: Colors.green,
            size: 15,
          ),
          title: t.common.copied,
        );
      }
      return AppButton(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ),
        onTap: _onTap,
        icon: Icon(
          Icons.copy,
          color: context.theme.colorScheme.primary,
          size: 15,
        ),
        title: widget.title ?? t.common.copy,
      );
    },
  );
}