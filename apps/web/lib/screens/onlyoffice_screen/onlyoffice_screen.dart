import 'package:common/bloc/onlyoffice_bloc/onlyoffice_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:domain/entity/common/telephony_project.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'onlyoffice_screen_view.dart';

/// Экран онлиофиса
@RoutePage()
class OnlyofficeScreen extends StatelessWidget {
  const OnlyofficeScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider<OnlyofficeBloc>(
        create: (_) => GetIt.I<OnlyofficeBloc>()
          ..init(projectId: context.read<TelephonyProject>().id)
          ..add(GetConfigEvent(startDate: DateTime(2020), endDate: DateTime.now())),
        child: const OnlyofficeScreenView(),
      );
}