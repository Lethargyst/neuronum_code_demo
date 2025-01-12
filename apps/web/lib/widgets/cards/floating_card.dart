import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lvm_telephony_web/utils/extensions/build_context.dart';
import 'package:lvm_telephony_web/widgets/buttons/app_button.dart';
import 'package:lvm_telephony_web/widgets/text/app_text.dart';

/// Floating-карточка, используемая для показа инфо на экране
class FloatingCard extends StatelessWidget {
  final String? title;
  final Widget? titleWidget;
  final TextStyle? titleStyle;
  final String? buttonTitle;
  final FutureOr<void> Function()? onTapButton;
  final Widget? buttonWidget;

  const FloatingCard({
    super.key,
    this.title,
    this.titleWidget,
    this.titleStyle,
    this.buttonTitle,
    this.onTapButton,
    this.buttonWidget,
  })  : assert(
          title != null || titleWidget != null,
          "title или titleWidget должны быть не null",
        ),
        assert(
          title == null || titleWidget == null,
          "title или titleWidget не могут быть не null одновременно",
        ),
        assert(
          buttonTitle == null || buttonWidget == null,
          "buttonTitle или buttonWidget не могут быть не null одновременно",
        );

  @override
  Widget build(BuildContext context) => DecoratedBox(
      decoration: BoxDecoration(
        color: context.theme.colorScheme.tertiary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          const BoxShadow(
            color: Color(0x26000000),
            blurRadius: 20,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null)
              Expanded(
                child: AppText.bold(context: context, text: title!),
              ),
            if (titleWidget != null) Expanded(child: titleWidget!),
            if (buttonTitle != null)
              AppButton.activeColor(
                padding: const EdgeInsets.symmetric(
                  horizontal: 44,
                  vertical: 14,
                ),
                title: buttonTitle,
                onTap: onTapButton ?? () {},
              ),
            if (buttonWidget != null) buttonWidget!,
          ],
        ),
      ),
    );
}
