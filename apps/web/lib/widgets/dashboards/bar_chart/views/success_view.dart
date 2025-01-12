part of '../bar_chart_group.dart';

class _SuccessView extends StatelessWidget {
  const _SuccessView();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<DashboardGroupBloc>();
    final state = bloc.state as SuccessState;

    return BarChartGroupSlider(group: state.dashboardGroup!);
  }
}
