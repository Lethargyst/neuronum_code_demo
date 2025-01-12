import 'package:flutter/material.dart';
import 'package:lvm_telephony_web/gen/translations.g.dart';
import 'package:lvm_telephony_web/utils/extensions/build_context.dart';
import 'package:lvm_telephony_web/widgets/buttons/app_button.dart';
import 'package:lvm_telephony_web/widgets/common/spacers.dart';

class PaginationErrorWidget extends StatelessWidget {
  final VoidCallback onRetryPagination;

  const PaginationErrorWidget({ required this.onRetryPagination, super.key});

  @override
  Widget build(BuildContext context) => Column(
      children: [
        Text(
          t.errors.somethingWentWrong,
          style: context.theme.textTheme.titleLarge,
        ),
        const SpacerV(16),
        AppButton(
          width: double.infinity,
          title: t.common.retry,
          textColor: context.theme.colorScheme.inversePrimary,
          buttonColor: context.theme.colorScheme.surface,
          enableBorder: false,
          onTap: onRetryPagination,
        ),
      ],
    );
}