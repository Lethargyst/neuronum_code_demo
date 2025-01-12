String? parseFileNameFromHeader(Map<String, dynamic>? header) {
  if (header == null) return null;
  
  final content = header['content-disposition'] as List<String>;
  final rawString = content.first;

  final regExp = RegExp(r'filename=(.+)');
  final Match? match = regExp.firstMatch(rawString);
  
  return match?.group(1);
}