part of 'call_card.dart';

class _IconTextRow extends StatelessWidget {
  final Widget icon;
  final String text;
  
  const _IconTextRow({ 
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      icon,
      const SpacerH(5),
      Flexible(
        child: AppText.primary(
          context: context, 
          text: text,
          enableSelection: true,
        ),
      ),
    ],
  );
}