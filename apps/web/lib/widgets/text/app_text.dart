import 'package:flutter/material.dart';
import 'package:lvm_telephony_web/theme/app_colors.dart';
import 'package:lvm_telephony_web/utils/extensions/build_context.dart';

class AppText extends StatelessWidget {
  final String text;
  final bool enableSelection;
  final bool ellispis;
  final int? maxLines;
  final TextStyle? style;
  final Color? color;
  final TextAlign? textAlign;
  
  const AppText({ 
    required this.text,
    this.style, 
    this.color = AppColors.black,
    this.textAlign,
    this.maxLines,
    this.enableSelection = false,
    this.ellispis = true,
    super.key, 
  });

  factory AppText.primary({
    required BuildContext context, 
    required String text,
    bool enableSelection = false,
    bool ellispis = true,
    int? maxLines,
    Color? color,
    TextAlign? textAlign,
  }) => 
    AppText(
      text: text,
      enableSelection: enableSelection,
      color: color,
      maxLines: maxLines,
      style: context.theme.textTheme.bodyMedium,
      textAlign: textAlign,
      ellispis: ellispis,
    );

  factory AppText.bold({
    required BuildContext context,
    required String text, 
    bool enableSelection = false,
    bool ellispis = true,
    int? maxLines,
    Color? color,
    TextAlign? textAlign,
  }) => 
    AppText(
      text: text,
      enableSelection: enableSelection,
      color: color,
      maxLines: maxLines,
      style: context.theme.textTheme.labelLarge,
      textAlign: textAlign,
      ellispis: ellispis,
    );

  factory AppText.large({
    required BuildContext context,
    required String text, 
    bool enableSelection = false,
    bool ellispis = true,
    int? maxLines,
    Color? color,
    TextAlign? textAlign,
  }) => 
    AppText(
      text: text,
      enableSelection: enableSelection,
      color: color,
      maxLines: maxLines,
      style: context.theme.textTheme.bodyLarge,
      textAlign: textAlign,
      ellispis: ellispis,
    );

  factory AppText.extraLarge({
    required BuildContext context,
    required String text, 
    bool enableSelection = false,
    bool ellispis = true,
    int? maxLines,
    Color? color,
    TextAlign? textAlign,
  }) => 
    AppText(
      text: text,
      enableSelection: enableSelection,
      color: color,
      maxLines: maxLines,
      style: context.theme.textTheme.titleLarge,
      textAlign: textAlign,
      ellispis: ellispis,
    );

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: style?.copyWith(
      color: color,
    ),
    overflow: ellispis ? TextOverflow.ellipsis : null,
    textAlign: textAlign,
    maxLines: maxLines,
  );
}