import 'package:flutter/material.dart';
import 'package:lvm_telephony_web/widgets/containers/text_box.dart';

/// Текстовая кнопка
class AppTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Widget? icon;
  final Color? color;
  final Color? textColor;
  
  const AppTextButton({
    required this.text,
    required this.onTap,
    this.icon,
    this.color,
    this.textColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Material(
    borderRadius: BorderRadius.circular(10),
    child: InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: SmallTextBox(
        text: text,
        icon: icon,
        color: color,
        textColor: textColor,
      ),
    ),
  );
}