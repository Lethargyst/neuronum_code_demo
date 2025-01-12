import 'package:common/bloc/dashboards_bloc/dashboards_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lvm_telephony_web/widgets/common/loader.dart';
import 'package:lvm_telephony_web/widgets/dashboards/bar_chart/bar_chart_group.dart';
import 'package:lvm_telephony_web/widgets/errors/somethig_went_wrong.dart';


part 'views/error_view.dart';
part 'views/loading_view.dart';
part 'views/success_view.dart';

class DashboardsScreenView extends StatelessWidget {
  const DashboardsScreenView({super.key});

  @override
  Widget build(BuildContext context) => BlocBuilder<DashboardsBloc, DashboardsState>(
    builder: (_, state) => switch (state) {
      SuccessState() => const _SuccessView(),
      FailureState() => const _ErrorView(),
      LoadingState() => const _LoadingView(),
    },
  );
}
