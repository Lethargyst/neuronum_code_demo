import 'package:common/bloc/current_call_bloc/current_call_bloc.dart';
import 'package:domain/entity/comment/comment.dart';
import 'package:domain/entity/response/tag.dart';
import 'package:domain/storage/user_storage.dart';
import 'package:domain/utils/extensions/date_time_extension.dart';
import 'package:domain/utils/extensions/string_extension.dart';
import 'package:domain/entity/common/call/call.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lvm_telephony_web/gen/assets.gen.dart';
import 'package:lvm_telephony_web/gen/translations.g.dart';
import 'package:lvm_telephony_web/theme/app_colors.dart';
import 'package:lvm_telephony_web/utils/extensions/build_context.dart';
import 'package:lvm_telephony_web/widgets/containers/text_box.dart';
import 'package:lvm_telephony_web/widgets/common/spacers.dart';
import 'package:lvm_telephony_web/widgets/text/app_text.dart';

part 'badge.dart';
part 'comments_list.dart';
part 'icon_text_row.dart';
part 'tags.dart';

/// Карточка звонка
class CallCard extends StatelessWidget {
  final Call call;
  final VoidCallback onTap;
  
  const CallCard({ 
    required this.call,
    required this.onTap, 
    super.key,
  });

  void _onTap(BuildContext context) {
    onTap.call();
    context.read<CurrentCallBloc>().add(PickCallEvent(call));
  }

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: context.theme.colorScheme.tertiary,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: context.theme.colorScheme.onSurfaceVariant,
          blurRadius: 10,
        ),
      ],
    ),
    child: Material(
      color: context.theme.colorScheme.tertiary,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => _onTap(context),
        child: Ink(
          child: Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: SizedBox(
                                  width: 400,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _IconTextRow(
                                        icon: Assets.icons.calls.calendar.svg(), 
                                        text: call.dateTime.viewFormat,
                                      ),
                                      const SpacerV(15),
                                      _IconTextRow(
                                        icon: Assets.icons.calls.service.svg(), 
                                        text: call.callData.service.or(t.common.undefined),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SpacerH(22),
                              Flexible(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _IconTextRow(
                                      icon: Assets.icons.calls.admin.svg(), 
                                      text: call.callData.adminName.or(t.common.undefined),
                                    ),
                                    const SpacerV(15),
                                    _IconTextRow(
                                      icon: Assets.icons.calls.person.svg(), 
                                      text: call.callData.clientName.or(t.common.undefined),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SpacerV(12),
                          _Tags(call),
                        ],
                      ),
                    ),
                  ),
              
                  if (!call.callData.comments.isEmpty)
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: _CommentsList(
                          key: ValueKey(call.callData.comments.toString()),
                          comments: call.callData.comments!,
                        ),
                      ),
                    ),
              
                  if (call.callData.isIncoming != null)
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: call.callData.isIncoming! 
                        ? Assets.icons.common.incomingCall.svg(
                          color: AppColors.green, 
                        )
                        : Assets.icons.common.outgoingCall.svg(
                          color: AppColors.blue,
                        ),
                    ),
                ],
              ),
              _Badge(callId: call.id),
            ],
          ),
        ),
      ),
    ),
  );
}