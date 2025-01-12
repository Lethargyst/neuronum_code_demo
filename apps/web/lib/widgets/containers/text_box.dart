import 'package:flutter/material.dart';
import 'package:lvm_telephony_web/utils/extensions/build_context.dart';
import 'package:lvm_telephony_web/widgets/text/app_text.dart';

/// Виджет, для отображение небольшой текстовой информаци
class SmallTextBox extends StatelessWidget {
  final String text;
  final Widget? icon;
  final Color? color;
  final Color? textColor;
  final List<BoxShadow>? boxShadow;
  
  const SmallTextBox({
    required this.text, 
    this.icon,
    this.color,
    this.textColor,
    this.boxShadow,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final widgetColor = color ?? context.theme.colorScheme.primary;

    return Ink(
      padding: EdgeInsets.only(top: 5, bottom: 5, left: icon == null ? 10 : 0, right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: widgetColor.withOpacity(0.3),
        boxShadow: boxShadow,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: icon,
            ),

          Flexible(
            child: AppText.bold(
              context: context, 
              text: text,
              color: textColor?.withOpacity(1) ?? widgetColor,
            ),
          ),
        ],
      ),
    );
  }
}