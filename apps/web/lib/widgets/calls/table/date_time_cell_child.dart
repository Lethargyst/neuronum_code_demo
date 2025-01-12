part of 'calls_table.dart';

class _DateTimeCellChild extends StatelessWidget {
  final DateTime dateTime;
  
  const _DateTimeCellChild({
    required this.dateTime, 
  });

  @override
  Widget build(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        dateTime.formattedDateString,
        style: context.theme.textTheme.bodyMedium,
      ),
      Text(
        dateTime.formattedTimeString,
        style: context.theme.textTheme.bodyMedium?.copyWith(
          color: context.theme.colorScheme.onSurface,
        ),
      ),
    ],
  );
}