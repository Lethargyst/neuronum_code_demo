import 'package:domain/entity/common/telephony_project.dart';
import 'package:equatable/equatable.dart';

/// Сущность данных пользователя, которые можно редактировать
class UserData extends Equatable {
  /// Имя
  final String? name;

  /// Фамилия
  final String? surname;

  /// Почта
  final String? email;

  const UserData({
    required this.name,
    required this.surname,
    required this.email,
  });

  UserData copyWith({
    String? name,
    String? surname,
    String? email,
  }) =>
      UserData(
        name: name ?? this.name,
        surname: surname ?? this.surname,
        email: email ?? this.email,
      );

  @override
  List<Object?> get props => [name, surname, email];
}

/// Пользователь
class User extends UserData {
  /// ID пользователя
  final String id;

  /// Список телефоний
  final List<TelephonyProject> projects;

  const User({
    required this.id,
    required this.projects,
    required super.name,
    required super.surname,
    required super.email,
  });

  @override
  List<Object?> get props => [name, surname, email, id];

  @override
  User copyWith({
    String? id,
    String? name,
    String? surname,
    String? email,
    List<TelephonyProject>? projects,
  }) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        surname: surname ?? this.surname,
        email: email ?? this.email,
        projects: projects ?? this.projects,
      );

  String? formatName() {
    final name = this.name;
    final surname = this.surname;

    final buffer = StringBuffer();
    if (name != null) buffer.write(name);
    if (surname != null) {
      if (name != null) buffer.write(" ");
      buffer.write(surname);
    }

    return buffer.toString().isEmpty ? null : buffer.toString();
  }
}
