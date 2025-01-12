part of 'call_card.dart';

class _CommentsList extends StatelessWidget {
  final List<CommentEntity> comments;

  const _CommentsList({
    required this.comments,
    super.key,
  });

  @override
  Widget build(BuildContext context) => ListView.separated(
    shrinkWrap: true,
    itemCount: comments.length,
    separatorBuilder: (_, __) => const SpacerV(8), 
    itemBuilder: (_, index) {
      if (comments[index].value.isEmpty) return const SizedBox.shrink();
      return _Comment(comments[index]);
    }, 
  );
}

class _Comment extends StatefulWidget {
  final CommentEntity comment;
  
  const _Comment(this.comment);

  @override
  State<_Comment> createState() => _CommentState();
}

class _CommentState extends State<_Comment> {
  late final userId = GetIt.I<UserStorage>().user?.id;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: userId == widget.comment.userId
        ? context.theme.colorScheme.primary.withOpacity(0.3)
        : context.theme.colorScheme.primaryFixed.withOpacity(0.3),
    ),
    child: RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '${widget.comment.userName}: \t',
            style: context.theme.textTheme.labelLarge,
          ),

          TextSpan(
            text: widget.comment.value,
            style: context.theme.textTheme.bodyMedium,
          ),
        ],
      ),
    ),
  );
}