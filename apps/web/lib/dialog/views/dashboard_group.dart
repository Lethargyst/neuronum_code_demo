part of '../app_dialog.dart';

class _DashboardGroup extends StatefulWidget {
  final DashboardGroupBloc groupBloc;
  final FiltersBloc filtersBloc;
  final int currentSlide;

  const _DashboardGroup({
    required this.groupBloc,
    required this.filtersBloc,
    this.currentSlide = 0,
  });

  @override
  State<_DashboardGroup> createState() => _DashboardGroupState();
}

class _DashboardGroupState extends State<_DashboardGroup> {
  late int _currentSlide = widget.currentSlide;

  @override
  void initState() {
    widget.filtersBloc.filtersAcceptNotifier.listen(_filtersAcceptListener);
    super.initState();
  }

  void _filtersAcceptListener((List<FilterEntity>, TimeRange) data) {
    widget.groupBloc.add(AcceptGroupFiltersEvent(data.$1, data.$2));
  }

  Future<void> _onDismiss(BuildContext context) => context.router.maybePop(_currentSlide);

  void _onSlideChanged(int index) => _currentSlide = index;

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider.value(
        value: widget.groupBloc,
      ),
      BlocProvider.value(
        value: widget.filtersBloc,
      ),
    ],
    child: Stack(
      children: [
        Positioned(
          top: 8,
          right: 8,
          child: AppIconButton(
            onTap: () async => _onDismiss(context),
            backgroundColor: context.theme.colorScheme.tertiary,
            icon: Icon(
              Icons.close,
              color: context.theme.colorScheme.primary,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(32),
          child: Row(
            children: [
              Container(
                width: 250,
                padding: const EdgeInsets.only(right: 16),
                child: const FiltersList(
                  exportEnabled: false,
                ),
              ),
              Expanded(
                child: BlocBuilder<DashboardGroupBloc, DashboardGroupState>(
                  builder: (context, state) => switch (state) {
                    LoadingState() => const Center(child: AppLoader()),
                    FailureState() => const SomethigWentWrong(),
                    SuccessState() => BarChartGroupSlider(
                      group: state.dashboardGroup!,
                      slim: false,
                      onSlideChanged: _onSlideChanged,
                      initialSlide: _currentSlide,
                    ),
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
