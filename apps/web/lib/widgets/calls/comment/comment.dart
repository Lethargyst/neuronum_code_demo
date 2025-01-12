import 'package:common/bloc/comment_bloc/comment_bloc.dart';
import 'package:common/bloc/current_call_bloc/current_call_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lvm_telephony_web/gen/assets.gen.dart';
import 'package:lvm_telephony_web/gen/translations.g.dart';
import 'package:lvm_telephony_web/utils/extensions/build_context.dart';
import 'package:lvm_telephony_web/widgets/common/loader.dart';
import 'package:lvm_telephony_web/widgets/common/spacers.dart';
import 'package:lvm_telephony_web/widgets/text/app_text.dart';
import 'package:lvm_telephony_web/widgets/text_fields/app_text_field.dart';

part 'comment_view.dart';

/// Редактируемое поле комментария звонка
class Comment extends StatelessWidget {
  /// Айди проекта телефонии
  final String projectId;

  /// Айди звонка
  final String callId;

  /// Комментарий, если был
  final String? initialComment;

  const Comment({
    required this.projectId,
    required this.callId,
    required this.initialComment,
    super.key,
  });

  void _updateCallData(BuildContext context, String comment) =>
    context.read<CurrentCallBloc>().add(SaveCommentEvent(comment));

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 16, bottom: 8),
    child: BlocProvider<CommentBloc>(
      create: (_) => GetIt.I<CommentBloc>()
        ..init(
          projectId: projectId,
          callId: callId,
          comment: initialComment,
        ),
      child: BlocListener<CommentBloc, CommentState>(
        listener: (_, state) => switch (state) {
          CommonState() => _updateCallData(context, state.comment),
          _ => null
        },
        child: const _CommentView(),
      ),
    ),
  );
}
