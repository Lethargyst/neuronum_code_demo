part of "../onlyoffice_screen_view.dart";

class _SuccessView extends StatefulWidget {
  final ValueNotifier<String> iframePointerEventsNotifier;

  const _SuccessView({
    required this.iframePointerEventsNotifier,
  });

  @override
  State<_SuccessView> createState() => _SuccessViewState();
}

class _SuccessViewState extends State<_SuccessView> {
  late html.IFrameElement _iframe;
  
  @override
  void initState() {
    widget.iframePointerEventsNotifier.addListener(
      () => _iframePointerEventsListener(widget.iframePointerEventsNotifier.value),
    );
    _updateIFrame();
    super.initState();
  }

  void _iframePointerEventsListener(String value) {
    _iframe.style.pointerEvents = value;
  }

  @override
  void didUpdateWidget(covariant _SuccessView oldWidget) {
    _updateIFrame();
    super.didUpdateWidget(oldWidget);
  }

  void _updateIFrame() {
    final state = context.read<OnlyofficeBloc>().state as SuccessState;
    final config = json.encode(state.config);

    final htmlContent = '''
      <html>
        <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <meta http-equiv="Content-Security-Policy" content="upgrade-insecure-requests" />
          <meta http-equiv=”Pragma” content=”no-cache”>
          <meta http-equiv=”Expires” content=”-1″>
          <meta http-equiv=”CACHE-CONTROL” content=”NO-CACHE”>
          <script type="text/javascript" src="${AppConfig().onlyOfficeDomain}/web-apps/apps/api/documents/api.js"></script>
          <title>Document</title>
          <style>
            html, body {sadsadsad
              margin: 0;
              padding: 0;
              width: 100%;
              height: 100%;
              overflow: hidden;
            }
            #placeholder {
              width: 100%;
              height: 100%;
              display: block;
            }
          </style>
        </head>
        <body>
          <div id="placeholder"></div>
          <script>
            this.docEditor = new DocsAPI.DocEditor("placeholder", $config);
          </script>
        </body>
      </html>
    ''';

    _iframe = html.IFrameElement()
      ..style.pointerEvents = widget.iframePointerEventsNotifier.value
      ..style.width = '100%'
      ..style.height = '100%'
      ..height = '100%'
      ..srcdoc = htmlContent;
  }

  @override
  Widget build(BuildContext context) {
    final viewId = UniqueKey().toString();

    ui_web.platformViewRegistry.registerViewFactory(
      viewId,
      (int viewId, {Object? params}) => _iframe,
    );

    return Center(
      child: HtmlElementView(
          viewType: viewId,
        ),
    );
  }
}
