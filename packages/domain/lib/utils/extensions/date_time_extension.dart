extension DateTimeX on DateTime {
  static DateTime time(int hour, int minute) => DateTime(0, 0, 0, hour, minute);

  /// Получить DateTime из следующих строк:
  /// date: "DD.MM.YYYY"
  /// time: "HH:MM:SS"
  static DateTime fromDateTimeStrings(String date, String time) {
    final dateList = date.split('.');
    final formattedDate = '${dateList[2]}-${dateList[1]}-${dateList[0]}';
    final formattedString = '$formattedDate $time';
    return DateTime.parse(formattedString);
  }

  static String? dateToJson(DateTime? value) => value?.formattedDateString;

  static String? timeToJson(DateTime? value) => value?.formattedTimeString;

  /// Получить дату в формате "DD.MM.YYYY"
  String get formattedDateString => 
    '${day.toString().padLeft(2, '0')}.${month.toString().padLeft(2, '0')}.$year';

  /// Получить время в формате "HH:MM:SS"
  String get formattedTimeString => 
    '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}:${second.toString().padLeft(2, '0')}';

  /// Получить время в формате "DD.MM.YYYY HH:MM:SS"
  String get viewFormat => '$formattedDateString $formattedTimeString';
}