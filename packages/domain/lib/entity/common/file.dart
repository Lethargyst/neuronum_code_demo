import 'dart:typed_data';

import 'package:equatable/equatable.dart';

/// Сущность файла
class FileEntity extends Equatable {
  /// Имя файла
  final String name;

  /// Содержимое файла
  final Uint8List content;

  const FileEntity({
    required this.name,
    required this.content,
  });

  FileEntity copyWith({
    String? name,
    Uint8List? content,
  }) =>
      FileEntity(
        name: name ?? this.name,
        content: content ?? this.content,
      );

  @override
  List<Object?> get props => [name, content];
}