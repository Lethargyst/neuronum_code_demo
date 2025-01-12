part of 'call_card.dart';

class _Badge extends StatefulWidget {
  final String callId;

  _Badge({ required this.callId });

  @override
  State<_Badge> createState() => _BadgeState();
}

class _BadgeState extends State<_Badge> {
  double? _parentHeight;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _parentHeight = (context.findRenderObject()?.parent as RenderBox?)?.size.height;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final pickedCallId = context.watch<CurrentCallBloc>().state.curCall?.id;

    if (pickedCallId != widget.callId) return const SizedBox.shrink();
    
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(8), 
        bottomLeft: Radius.circular(8),
      ),
      child: Container(
        color: context.theme.colorScheme.primary,
        width: 5,
        height: _parentHeight,
      ),
    );
  }
}