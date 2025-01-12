import 'package:common/gen/translations.g.dart';
import 'package:flutter/material.dart';
import 'package:lvm_telephony_web/utils/extensions/build_context.dart';

class SomethigWentWrong extends StatelessWidget {
  const SomethigWentWrong({ super.key });

  @override
  Widget build(BuildContext context) => Center(
    child: Text(
      t.errors.somethingWentWrong,
      style: context.theme.textTheme.bodyLarge,
    ),
  );
}