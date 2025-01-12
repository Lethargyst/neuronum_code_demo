part of 'calls_table.dart';

class _DataCellTextChild extends StatefulWidget {
  final String text;

  const _DataCellTextChild(this.text);

  @override
  State<_DataCellTextChild> createState() => _DataCellTextChildState();
}

class _DataCellTextChildState extends State<_DataCellTextChild> {
  final _truncatedMaxLength = 50;

  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;


  void _showDescription() {
    _openDropdown();
    setState(() {});
  }

  void _removeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _openDropdown() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject()! as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          child: TapRegion(
            onTapOutside: (_) => _removeDropdown(),
            child: Container(
              padding: const EdgeInsets.all(8),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(context).height - offset.dy - 16,
                maxWidth: MediaQuery.sizeOf(context).width - offset.dx - 16,
              ),
              decoration: BoxDecoration(
                color: context.theme.colorScheme.tertiary,
              ),
              child: Material(
                color: context.theme.colorScheme.tertiary,
                child: AppScrollWrapper(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.text,
                      ),
                      CopyButton(copyText: widget.text),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => CompositedTransformTarget(
    link: _layerLink,
    child: ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 200,
      ),
      child: InkWell(
        onTap: widget.text.length > _truncatedMaxLength ? _showDescription : null,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Text(_truncateDescription(widget.text)),
        ),
      ),
    ),
  );

  String _truncateDescription(String description) => 
    description.length > _truncatedMaxLength
      ? '${description.substring(0, _truncatedMaxLength)}...'
      : description;
}