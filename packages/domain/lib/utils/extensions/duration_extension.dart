extension DurationX on Duration {
  /// Получить строку вида "mm:ss"
  String get viewFormat => 
    "${(inSeconds ~/ 60).toString().padLeft(2, '0')}:${(inSeconds % 60).toString().padLeft(2, '0')}";
}