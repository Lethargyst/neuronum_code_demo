import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:lvm_telephony_web/theme/app_colors.dart';
import 'package:lvm_telephony_web/utils/extensions/build_context.dart';

/// Виджет с текстом звонка (форматированными строками, подсветкой ключевых слов и т.д.)
class CallText extends StatelessWidget {
  final String text;
  
  const CallText({ required this.text, super.key });

  @override
  Widget build(BuildContext context) {
    final textWidgets = _parseTextWithTabs(context, text);

    return Column(
      spacing: 10,
      children: textWidgets,
    );
  }

  List<Widget> _parseTextWithTabs(BuildContext context, String text) {
    final parts = const LineSplitter().convert(text);

    return [
      for (int i = 0; i < parts.length; ++i)
        _SpeechBubble(
          text: parts[i],
          isRight: parts[i]
            .toLowerCase()
            /// TODO: Ну, с этим однозначно надо что-то сделать...
            .contains('администратор:'),
        ),
    ];
  }
}

class _SpeechBubble extends StatelessWidget {
  final String text;
  final bool isRight;
  
  const _SpeechBubble({
    required this.text,
    required this.isRight,
  });

  @override
  Widget build(BuildContext context) {
    final colors = <Color>[
      context.theme.colorScheme.primary.withOpacity(0.3),
      context.theme.colorScheme.surface,
    ];

    return Align(
      alignment: isRight 
        ? Alignment.centerRight 
        : Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(
          left: isRight ? 60 : 0,
          right: isRight ? 0 : 60,
        ),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colors[isRight ? 0 : 1],
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(8),
              topRight: const Radius.circular(8),
              bottomLeft: Radius.circular(isRight ? 16 : 0),
              bottomRight: Radius.circular(isRight ? 0 : 16),
            ),
          ),
          child: Html(
            data: text,
            shrinkWrap: true,
            style: {
              "b": Style(
                fontSize: FontSize(12),
                height: Height(1.2),
                fontWeight: FontWeight.w700,
                color: AppColors.black,
              ),
            },
          ),
        ),
      ),
    );
  }
}