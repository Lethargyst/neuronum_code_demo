import 'package:common/bloc/dashboard_group_bloc/dashboard_group_bloc.dart';
import 'package:common/bloc/filters_bloc/filters_bloc.dart';
import 'package:domain/entity/common/dashboards/dashboard_group/dashboard_group.dart';
import 'package:domain/entity/common/telephony_project.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lvm_telephony_web/screens/project/dashboards_screen/widgets/bar_chart_group_slider.dart';
import 'package:lvm_telephony_web/widgets/common/loader.dart';
import 'package:lvm_telephony_web/widgets/errors/somethig_went_wrong.dart';

part 'views/success_view.dart';
part 'views/loading_view.dart';
part 'views/failure_view.dart';

class BarChartGroupWidget extends StatelessWidget {
  final DashboardGroupFilters filters;

  const BarChartGroupWidget({required this.filters, super.key});

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => GetIt.I<DashboardGroupBloc>()
              ..init(
                projectId: context.read<TelephonyProject>().id,
                group: filters.filterId,
                filtersIds: filters.options,
              )
              ..add(const GetDashboardGroupEvent()),
          ),
          BlocProvider(
            create: (context) => GetIt.I<FiltersBloc>()
              ..init(context.read<TelephonyProject>().id)
              ..add(GetLocalFiltersEvent(filters.options)),
          ),
        ],
        child: BlocBuilder<DashboardGroupBloc, DashboardGroupState>(
          builder: (_, state) => switch (state) {
            SuccessState() => const _SuccessView(),
            LoadingState() => const _LoadingView(),
            FailureState() => const _FailureView(),
          },
        ),
      );
}
