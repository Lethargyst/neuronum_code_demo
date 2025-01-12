import 'package:common/bloc/calls_bloc/calls_bloc.dart';
import 'package:common/bloc/current_call_bloc/current_call_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lvm_telephony_web/screens/project/calls_screen/notifiers/current_call_card_scroll_notifier.dart';
import 'package:lvm_telephony_web/utils/extensions/build_context.dart';
import 'package:lvm_telephony_web/widgets/app_scroll/app_scroll_wrapper.dart';
import 'package:lvm_telephony_web/widgets/calls/call_card/call_card.dart';
import 'package:lvm_telephony_web/widgets/calls/call_tab/call_tab.dart';
import 'package:lvm_telephony_web/widgets/containers/text_box.dart';
import 'package:lvm_telephony_web/widgets/errors/pagination_error.dart';
import 'package:lvm_telephony_web/widgets/errors/somethig_went_wrong.dart';
import 'package:lvm_telephony_web/widgets/common/loader.dart';
import 'package:lvm_telephony_web/widgets/common/spacers.dart';
import 'package:lvm_telephony_web/widgets/filters/filters_list.dart';

part 'views/error_view.dart';
part 'views/loading_view.dart';
part 'views/success_view.dart';

class CallsScreenView extends StatelessWidget {
  const CallsScreenView({super.key});

  @override
  Widget build(BuildContext context) => Row(
    children: [
      const SizedBox(
        width: 250,
        child: Padding(
          padding: EdgeInsets.only(top: 16, bottom: 16, left: 16),
          child: FiltersList(),
        ),
      ),
      Expanded( 
        child: BlocBuilder<CallsBloc, CallsState>(
          builder: (_, state) => switch (state) {
            SuccessState() => const _SuccessView(),
            FailureState() => const _ErrorView(),
            LoadingState() => const _LoadingView(),
          },
        ),
      ),
    ],
  );
}
