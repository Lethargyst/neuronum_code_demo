part of 'call_card.dart';

class _Tags extends StatelessWidget {
  final Call call;

  const _Tags(this.call);

  Widget? _getIcon(TagEntity tag) {
    if (tag.tagType == null) return null;

    final icon = switch (tag.tagType!) {
      TagType.warning => Assets.icons.calls.lightning.svg(
        colorFilter: ColorFilter.mode(
          Color(tag.color).withOpacity(1), 
          BlendMode.srcIn,
        ),
      ),
      TagType.time => Assets.icons.calls.history.svg(
        colorFilter: ColorFilter.mode(
          Color(tag.color).withOpacity(1), 
          BlendMode.srcIn,
        ),
      ),
      TagType.info => Icon(
        Icons.info_outline,
        size: 14,
        color: Color(tag.color).withOpacity(1),
      ),
      TagType.good => Icon(
        Icons.thumb_up_alt_rounded, 
        size: 14,
        color: Color(tag.color).withOpacity(1),
      )
    };

    return icon;
  }

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 10,
    runSpacing: 5,
    children: [
      if (call.callData.recordStatus.isNotEmpty) 
        SmallTextBox(
          text: call.callData.recordStatus!,
        ),
      if (call.refuseAnalytics.isNotEmpty) 
        SmallTextBox(
          text: call.refuseAnalytics!,
          icon: Assets.icons.calls.cancel.svg(),
          color: context.theme.colorScheme.surface,
          textColor: context.theme.colorScheme.onSurface,
        ),

      for (final tag in call.tags)
        SmallTextBox(
          text: tag.value,
          icon: _getIcon(tag),
          color: Color(tag.color).withOpacity(1),
          textColor: Color(tag.color).withOpacity(1),
        ),
    ],
  );
}