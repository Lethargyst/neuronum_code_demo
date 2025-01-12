extension StringX on String? {
  String or(String other) {
    if (this == null || this!.isEmpty) return other;
    return this!;
  }

  bool get isEmpty => this == null || this == '';

  bool get isNotEmpty => !isEmpty;
}