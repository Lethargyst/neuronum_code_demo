part of 'sign_in_bloc.dart';

sealed class SignInEvent extends Equatable {
  const SignInEvent();
}

/// Изменить значение логина
class EditLoginEvent extends SignInEvent {
  final String login;

  const EditLoginEvent(this.login);

  @override
  List<Object?> get props => [login];
}

/// Изменить значение пароля
class EditPasswordEvent extends SignInEvent {
  final String password;

  const EditPasswordEvent(this.password);

  @override
  List<Object?> get props => [password];
}

/// Войти в аккаунт
class LoginEvent extends SignInEvent {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}
