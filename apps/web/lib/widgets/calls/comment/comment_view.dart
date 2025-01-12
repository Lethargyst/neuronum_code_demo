part of 'comment.dart';

class _CommentView extends StatefulWidget {
  const _CommentView();

  @override
  State<_CommentView> createState() => _CommentViewState();
}

class _CommentViewState extends State<_CommentView> {
  late final CommentBloc _bloc;
  final _commentMaxLength = 128;

  final ValueNotifier<int> _commentLength = ValueNotifier(0);

  @override
  void initState() {
    _bloc = context.read<CommentBloc>();
    _commentLength.value = _bloc.initialComment.length;
    super.initState();
  }

  void _onStartEditing() => _bloc.add(const StartEditingEvent());

  void _onEditing(String value) {
    _bloc.add(EditCommentEvent(value));
    _commentLength.value = value.length;
  }

  void _onDeleteComment() => _bloc.add(const DeleteCommentEvent());

  void _onSave() => _bloc.add(const SaveEvent());

  void _onClose() => _bloc.add(const StopEditingEvent());

  @override
  Widget build(BuildContext context) => BlocBuilder<CommentBloc, CommentState>(
    builder: (context, state) {
      _commentLength.value = switch (state) {
        CommonState() => _bloc.initialComment.length,
        EditingState() => state.comment.length,
      };
      return Column(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: context.theme.colorScheme.tertiary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: AppTextField(
              onTap: _onStartEditing,
              hintText: t.comment.leaveComment,
              initialValue: switch (state) {
                CommonState() => _bloc.initialComment,
                EditingState() => state.comment,
              },
              onChangeValue: _onEditing,
              onSubmitted: _onSave,
              inputAction: TextInputAction.send,
              inputFormatters: [
                LengthLimitingTextInputFormatter(_commentMaxLength),
                FilteringTextInputFormatter.deny(RegExp(r"\n")),
              ],
            ),
          ),
          const SpacerV(5),
          if (state is EditingState)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ListenableBuilder(
                  listenable: _commentLength, 
                  builder: (context, __) => AppText.primary(
                    context: context,
                    text: '${_commentLength.value} / $_commentMaxLength',
                    color: context.theme.colorScheme.tertiaryContainer,
                  ),
                ),
                Builder(
                  builder: (_) => switch (state.status) {
                    CommentStatus.loading => const AppLoader(size: 18),
                    CommentStatus.success => StreamBuilder<bool>(
                      stream: _bloc.validationError,
                      initialData: true,
                      builder: (context, value) {
                        if (value.data!)  {
                          return InkWell(
                            onTap: _onClose,
                            child: Icon(
                              Icons.close,
                              color: context.theme.colorScheme.primary,
                              size: 20,
                            ),
                          );
                        }
              
                        return Row(
                          children: [
                            if (_bloc.initialComment.isNotEmpty)
                              InkWell(
                                onTap: _onDeleteComment,
                                child: Assets.icons.common.trash.svg(
                                  colorFilter: ColorFilter.mode(
                                    context.theme.colorScheme.error, 
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            const SpacerH(30),
                            InkWell(
                              onTap: _onSave,
                              child: Icon(
                                Icons.send,
                                color: context.theme.colorScheme.primary,
                                size: 20,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    /// TODO: Добавить обработку ошибки
                    _ => throw UnimplementedError()
                  },
                ),
              ],
            ),
        ],
      );
    },
  );
}