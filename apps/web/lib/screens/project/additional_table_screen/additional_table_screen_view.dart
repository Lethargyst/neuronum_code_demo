import 'package:common/bloc/additional_table_bloc/additional_table_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lvm_telephony_web/widgets/calls/table/calls_table.dart';
import 'package:lvm_telephony_web/widgets/common/loader.dart';


part 'views/error_view.dart';
part 'views/loading_view.dart';
part 'views/success_view.dart';

class AdditionalTableScreenView extends StatelessWidget {
  const AdditionalTableScreenView({super.key});

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Scaffold(
      body: BlocBuilder<AdditionalTableBloc, AdditionalTableState>(
        builder: (_, state) => switch (state) {
          SuccessState() => const _SuccessView(),
          FailureState() => const _ErrorView(),
          LoadingState() => const _LoadingView(),
        },
      ),
    ),
  );
}
