import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:lvm_telephony_web/utils/extensions/build_context.dart';
import 'package:lvm_telephony_web/widgets/calls/call_text.dart';
import 'package:lvm_telephony_web/widgets/text/app_text.dart';

/// Аккордеон для таба звонка
class TextAccordion extends StatelessWidget {
  final String title;
  final String text;

  const TextAccordion({ 
    required this.title,
    required this.text,
    super.key, 
  });

  @override
  Widget build(BuildContext context) => ExpansionTileCard(
    borderRadius: BorderRadius.zero,
    elevation: 0,
    expandedColor: context.theme.colorScheme.tertiary,
    baseColor: context.theme.colorScheme.tertiary,
    expandedTextColor: context.theme.colorScheme.primary,
    title: AppText.bold(context: context, text: title),
    children: [
      Padding(
        padding: const EdgeInsets.all(10),
        child: CallText(text: text),
      ),
    ],
  );
}