part of "../calls_screen_view.dart";

class _SuccessView extends StatefulWidget {
  const _SuccessView();

  @override
  State<_SuccessView> createState() => _SuccessViewState();
}

class _SuccessViewState extends State<_SuccessView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    context.read<CurrentCallCardScrollNotifier>().addListener(_scrollNotifierListener);
    super.initState();
  }

  Future<void> _scrollNotifierListener() async {
    final offset = context.read<CurrentCallCardScrollNotifier>().offset;
    _scrollController.animateTo(
      offset,
      duration: const Duration(seconds: 1),
      curve: Curves.ease,
    );
  }

  void _onPagination() => context.read<CallsBloc>().add(const PaginationEvent());

  void _onCardTap() =>
      context.read<CurrentCallCardScrollNotifier>().update(_scrollController.position.pixels);

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Flexible(
        child: BlocBuilder<CallsBloc, CallsState>(
          builder: (context, state) {
            final curState = state as SuccessState; 
        
            return Stack(
              children: [
                AppScrollWrapper(
                  onPagination: _onPagination,
                  controller: _scrollController,
                  child: Column(
                    children: [
                      ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(16),
                        itemCount: curState.items.length,
                        separatorBuilder: (_, __) => const SpacerV(8),
                        itemBuilder: (_, index) => CallCard(
                          key: ValueKey<String>(curState.items[index].id),
                          call: curState.items[index],
                          onTap: _onCardTap,
                        ),
                      ),
                  
                      if (curState.nextPage != null) ...[
                        const SpacerV(32),
                        if (curState.paginationError != null)
                          PaginationErrorWidget(
                            onRetryPagination: _onPagination,
                          ),
                        if (curState.isPaginating && curState.paginationError == null)
                          const AppLoader(
                            size: 50,
                          ),
                        const SpacerV(48),
                      ],
                    ],
                  ),
                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: context.theme.colorScheme.onSurfaceVariant,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          child: SmallTextBox(
                            key: ValueKey(curState.items.length),
                            text: '${curState.items.length} / ${curState.totalItemsCount}',
                            textColor: context.theme.colorScheme.onSurface,
                            color: context.theme.colorScheme.tertiary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      BlocBuilder<CurrentCallBloc, CurrentCallState>(
        builder: (_, state) {
          if (state.curCall == null) return const SizedBox.shrink();

          return Flexible(
            child: Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 16, right: 16),
              child: CallTab(call: state.curCall!),
            ),
          );
        },
      ),
    ],
  );
}
