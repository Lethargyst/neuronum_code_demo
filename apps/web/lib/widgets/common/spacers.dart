import 'package:flutter/material.dart';

class SpacerH extends StatelessWidget {
  final double width;
  const SpacerH(
    this.width, {
    super.key,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
        width: width,
      );
}

class SpacerV extends StatelessWidget {
  final double height;
  const SpacerV(
    this.height, {
    super.key,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
        height: height,
      );
}
