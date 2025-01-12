import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lvm_telephony_web/utils/extensions/build_context.dart';

class AppLoader extends StatelessWidget {
  final Color? color;
  final double? size;

  const AppLoader({ 
    this.color, 
    this.size,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Center(
    child: LayoutBuilder(
      builder: (context, constraints) {
        final maxSize = size ?? constraints.maxHeight;
        final loaderSize = maxSize <= 50 ? maxSize : 50;
 
        return LoadingAnimationWidget.threeArchedCircle(
          color: color ?? context.theme.colorScheme.primary, 
          size: loaderSize as double,
        );
      },
    ),
  );
}