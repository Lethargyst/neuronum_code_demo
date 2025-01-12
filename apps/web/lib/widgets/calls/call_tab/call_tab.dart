import 'package:common/bloc/current_call_bloc/current_call_bloc.dart';
import 'package:domain/entity/comment/comment.dart';
import 'package:domain/entity/common/call/call.dart';
import 'package:domain/storage/user_storage.dart';
import 'package:domain/utils/extensions/date_time_extension.dart';
import 'package:domain/utils/extensions/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:lvm_telephony_web/gen/translations.g.dart';
import 'package:lvm_telephony_web/screens/project/calls_screen/notifiers/current_call_card_scroll_notifier.dart';
import 'package:lvm_telephony_web/utils/extensions/build_context.dart';
import 'package:lvm_telephony_web/widgets/buttons/copy_button.dart';
import 'package:lvm_telephony_web/widgets/calls/audio_player_bar.dart';
import 'package:lvm_telephony_web/widgets/calls/call_tab/text_accordion.dart';
import 'package:lvm_telephony_web/widgets/calls/call_text.dart';
import 'package:lvm_telephony_web/widgets/calls/comment/comment.dart';
import 'package:lvm_telephony_web/widgets/common/data_field.dart';
import 'package:lvm_telephony_web/widgets/common/spacers.dart';
import 'package:lvm_telephony_web/widgets/text/app_text.dart';
import 'package:provider/provider.dart';
import 'package:domain/utils/extensions/list_extension.dart';

/// Виджет таба с подробными данными о звонке
class CallTab extends StatefulWidget {
  final Call call;
  
  const CallTab({ required this.call, super.key });

  @override
  State<CallTab> createState() => _CallTabState();
}

class _CallTabState extends State<CallTab> {
  CommentEntity? _initialComment;

  @override
  void initState() {
    _updateInitialComment();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CallTab oldWidget) {
    _updateInitialComment();
    super.didUpdateWidget(oldWidget);
  }

  void _updateInitialComment() {
    final userId = GetIt.I<UserStorage>().user?.id;
    _initialComment = widget.call.callData.comments?.firstWhereOrNull((e) => e.userId == userId);
  }

  void _onClose() => context.read<CurrentCallBloc>().add(const ClearEvent());

  void _toCard() => context.read<CurrentCallCardScrollNotifier>().notify();
  
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => Container(
      height: constraints.maxHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: context.theme.colorScheme.tertiary,
        boxShadow: [
          BoxShadow(
            color: context.theme.colorScheme.onSurfaceVariant,
            blurRadius: 10,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: _toCard,
                    child: AppText.bold(
                      context: context, 
                      text: t.calls.toCard,
                      color: context.theme.colorScheme.primary,
                    ),
                  ),
                  InkWell(
                    onTap: _onClose,
                    child: Icon(
                      Icons.close,
                      color: context.theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Comment(
                        projectId: widget.call.projectId,
                        callId: widget.call.id,
                        initialComment: _initialComment?.value,
                        key: ValueKey<String>(
                          '${widget.call.projectId}${widget.call.id}${_initialComment?.value}',
                        ),
                      ),
                    ),
                    const SpacerV(5),
                    _CallData(widget.call),
                    const SpacerV(5),
                    if (widget.call.callAnalytics != null)
                      TextAccordion(title: t.calls.callAnalytics, text: widget.call.callAnalytics!),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: CallText(text: widget.call.text),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: CopyButton(
                        copyText: widget.call.text,
                        title: t.calls.copyCallText,
                      ),
                    ),
                    const SpacerV(16),
                  ],
                ),
              ),
            ),
            AudioPlayerBar(
              key: ValueKey('${widget.call.projectId}${widget.call.id}'),
              projectId: widget.call.projectId,
              callId: widget.call.id,
            ),
          ],
        ),
      ),
    ),
  );
}

class _CallData extends StatelessWidget {
  final Call call;
  
  const _CallData(this.call);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ColoredColumn(
          children: [
            DataField(title: t.calls.date, text: call.dateTime.formattedDateString),
            DataField(title: t.calls.time, text: call.dateTime.formattedTimeString),
            DataField(title: t.calls.phoneNumber, text: call.callData.phoneNumber.or(t.common.undefined)),
            DataField(title: t.calls.virtualNumber, text: call.callData.virtualNumber.or(t.common.undefined)),
          ],
        ),
        const SpacerV(5),
        _ColoredColumn(
          children: [
            DataField(title: t.calls.clientName, text: call.callData.clientName.or(t.common.undefined)),
            DataField(title: t.calls.wasBefore, text: call.callData.visitedBefore.or(t.common.undefined)),
          ],
        ),
        const SpacerV(5),
        _ColoredColumn(
          children: [
            DataField(title: t.calls.adminName, text: call.callData.adminName.or(t.common.undefined)),
            DataField(title: t.calls.recordStatus, text: call.callData.recordStatus.or(t.common.undefined)),
          ],
        ),
        const SpacerV(5),
        _ColoredColumn(
          children: [
            DataField(title: t.calls.refuseAnalytics, text: call.refuseAnalytics.or(t.common.undefined)),
          ],
        ),
      ],
    ),
  );
}

class _ColoredColumn extends StatelessWidget {
  final List<Widget> children;
  
  const _ColoredColumn({ required this.children });

  @override
  Widget build(BuildContext context) => Container(
    width: double.maxFinite,
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: context.theme.colorScheme.surface,
    ),
    child: SelectionArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    ),
  );
}