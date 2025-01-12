import 'package:equatable/equatable.dart';

/// Сущность телефонии 
class TelephonyProject extends Equatable {
  /// ID телефонии
  final String id;

  /// Список ID таблиц
  final List<String> callsTablesIds;

  const TelephonyProject({
    required this.id,
    required this.callsTablesIds,
  });

  TelephonyProject copyWith({
    String? id,
    List<String>? callsTablesIds,
  }) =>
      TelephonyProject(
        id: id ?? this.id,
        callsTablesIds: callsTablesIds ?? this.callsTablesIds,
      );

  @override
  List<Object?> get props => [id, callsTablesIds];
}