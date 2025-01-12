import 'package:flutter/material.dart';
import 'package:lvm_telephony_web/utils/extensions/build_context.dart';

/// Текстовое поле
class DataField extends StatelessWidget {
  final String title;
  final String text;

  const DataField({ 
    required this.title,
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    child: RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$title: ',
            style: context.theme.textTheme.labelLarge,
          ),
          TextSpan(
            text: text,
            style: context.theme.textTheme.bodyMedium,
          ),
        ],
      ),
    ),
  );
}