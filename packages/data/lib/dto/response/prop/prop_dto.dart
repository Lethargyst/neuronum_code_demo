import 'dart:convert';

import 'package:domain/entity/response/prop.dart';
import 'package:domain/service/cache/cache_client.dart';

/// DTO характеристики
class PropDto implements CacheObject{
  /// Ключ
  final String key;
  /// Значение
  final String value;

  const PropDto({
    required this.key,
    required this.value,
  });

  factory PropDto.fromJson(Map<String, dynamic> json) => PropDto(
    key: json['first'] as String,
    value: json['second'].runtimeType == int 
      ? json['second'].toString()
      : json['second'] as String,
  );

  static List<PropDto> fromJsonList(List<dynamic> json) =>
    json.map((e) => PropDto.fromJson(e as Map<String, dynamic>)).toList();


  Map<String, dynamic> toJson() => {
    'first': key,
    'second': value,
  };

  Prop toEntity() => Prop(
    key: key,
    value: value,
  );

  @override
  String toJsonString() => jsonEncode(toJson());
}

extension Parser on List<PropDto> {
  List<Prop> toEntity() => map((e) => e.toEntity()).toList();

  List<Map<String, dynamic>> toJson() => map((e) => e.toJson()).toList();
}