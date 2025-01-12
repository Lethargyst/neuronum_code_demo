part of "../dashboards_screen_view.dart";

class _SuccessView extends StatefulWidget {
  const _SuccessView();

  @override
  State<_SuccessView> createState() => _SuccessViewState();
}

class _SuccessViewState extends State<_SuccessView> {

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<DashboardsBloc>();
    final state = bloc.state as SuccessState;

    return GridView.count(
      crossAxisCount: 4,
      padding: const EdgeInsets.all(16),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        for (final groupOptions in state.options)
          BarChartGroupWidget(filters: groupOptions),
      ],
    );
  }
}
