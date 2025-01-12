import 'package:equatable/equatable.dart';

/// Сущность данных логина
class SignInRequest extends Equatable {
  /// Логин
  final String login;

  /// Пароль
  final String password;

  const SignInRequest({
    required this.login,
    required this.password,
  });

  @override
  List<Object?> get props => [login, password];
}