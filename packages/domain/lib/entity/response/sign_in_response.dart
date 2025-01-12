import 'package:domain/entity/common/auth.dart';
import 'package:domain/entity/common/user.dart';
import 'package:equatable/equatable.dart';

/// Сущность данных ответа логина
class SignInResponse extends Equatable {
  /// Сущность пользователя
  final User user;

  /// Сущность данных авторизации
  final AuthData authData;

  const SignInResponse({
    required this.user,
    required this.authData,
  });
  
  @override
  List<Object?> get props => [user, authData];
}