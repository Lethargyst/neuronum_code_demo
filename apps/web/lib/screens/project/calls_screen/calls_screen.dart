import 'package:common/bloc/calls_bloc/calls_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:common/bloc/current_call_bloc/current_call_bloc.dart';
import 'package:common/bloc/filters_bloc/filters_bloc.dart';
import 'package:domain/entity/common/call/call.dart';
import 'package:domain/entity/common/filter.dart';
import 'package:domain/entity/time_range/time_range.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lvm_telephony_web/screens/project/calls_screen/notifiers/current_call_card_scroll_notifier.dart';
import 'package:provider/provider.dart';

import 'calls_screen_view.dart';

/// Экран звонков
@RoutePage()
class CallsScreen extends StatefulWidget {
  final String projectId;

  const CallsScreen({ 
    required this.projectId, 
    super.key, 
  });

  @override
  State<CallsScreen> createState() => _CallsScreenState();
}

class _CallsScreenState extends State<CallsScreen> {
  late CallsBloc _callsBloc;
  late CurrentCallBloc _currentCallBloc;
  late FiltersBloc _filtersBloc;

  @override
  void initState() {
    _filtersBloc = GetIt.I<FiltersBloc>()
      ..init(widget.projectId)
      ..add(const GetFiltersEvent());

    _currentCallBloc = GetIt.I<CurrentCallBloc>()
      ..callEditsStream.listen(_callEditsListener);

    _callsBloc = GetIt.I<CallsBloc>()
      ..init(widget.projectId)
      ..add(const GetCallsEvent(withInitialFilters: true));

    _filtersBloc.filtersAcceptNotifier.listen(_filtersListener);
    

    super.initState();
  }

  void _callEditsListener(Call call) => _callsBloc.add(UpdateCallEvent(call));

  void _filtersListener((List<FilterEntity>, TimeRange) data) {
    _callsBloc.add(SetFiltersEvent(filters: data.$1, interval: data.$2));
    _currentCallBloc.add(const ClearEvent());
  }

  @override
  Future<void> dispose() async {
    _callsBloc.close();
    _filtersBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MultiProvider(
    providers: [
      ChangeNotifierProvider<CurrentCallCardScrollNotifier>(
        create: (_) => CurrentCallCardScrollNotifier(),
      ),
    ],
    child: MultiBlocProvider(
      providers: [
        BlocProvider<CurrentCallBloc>.value(
          value: _currentCallBloc, 
        ),
        BlocProvider<CallsBloc>.value(
          value: _callsBloc, 
        ),
        BlocProvider<FiltersBloc>.value(
          value: _filtersBloc,
        ),
      ],
      child: const CallsScreenView(),
    ),
  );
}
