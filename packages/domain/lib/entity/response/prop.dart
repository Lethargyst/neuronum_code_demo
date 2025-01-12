import 'dart:convert';

import 'package:domain/service/cache/cache_client.dart';
import 'package:equatable/equatable.dart';

/// Сущность характерирстики
class Prop extends Equatable implements CacheObject {
  /// Ключ
  final String key;
  /// Значение
  final String value;

  const Prop({
    required this.key,
    required this.value,
  });

  Prop copyWith({
    String? key,
    String? value,
  }) 
    => Prop(
      key: key ?? this.key,
      value: value ?? this.value,
    );

  @override
  List<Object?> get props => [key, value];

  @override
  String toJsonString() => jsonEncode({'first': key, 'second': value});
}

class PropsListCache implements CacheObject {
  final List<Prop> props;

  const PropsListCache(this.props);

  @override
  String toJsonString() => jsonEncode(
    props
    .map((e) => e.toJsonString())
    .toList()
    .toString(),
  );
}
