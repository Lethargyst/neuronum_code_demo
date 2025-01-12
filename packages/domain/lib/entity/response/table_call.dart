import 'package:domain/entity/response/prop.dart';
import 'package:equatable/equatable.dart';

/// Сущность звонка таблицы
class TableCall extends Equatable {
  /// Айди звонка
  final String id;
  /// Номер телефона клиента
  final String phoneNumber;
  /// Дата и время звонка
  final DateTime dateTime;
  /// Входящий лм звонок
  final bool isIncoming;
  /// Характеристики звонка
  final List<Prop> properties;

  const TableCall({
    required this.id,
    required this.phoneNumber,
    required this.dateTime,
    required this.isIncoming,
    required this.properties,
  });

  TableCall copyWith({
    String? id,
    String? phoneNumber,
    DateTime? dateTime,
    bool? isIncoming,
    List<Prop>? properties,
  }) => TableCall(
    id: id ?? this.id,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    dateTime: dateTime ?? this.dateTime,
    isIncoming: isIncoming ?? this.isIncoming,
    properties: properties ?? this.properties,
  );

  @override
  List<Object?> get props => [id, phoneNumber, dateTime, isIncoming, properties];

  void get callData {}
}
