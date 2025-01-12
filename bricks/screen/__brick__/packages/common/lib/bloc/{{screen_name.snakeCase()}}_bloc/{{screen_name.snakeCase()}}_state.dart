part of '{{screen_name.snakeCase()}}_bloc.dart';

sealed class {{screen_name.pascalCase()}}State extends Equatable {
  const {{screen_name.pascalCase()}}State();
}

/// Стейт успеха
class SuccessState extends {{screen_name.pascalCase()}}State {
  const SuccessState();

  @override
  List<Object> get props => [];
}

/// Стейт ошибки
class FailureState extends {{screen_name.pascalCase()}}State {
  final String message;

  const FailureState(this.message);
  
  @override
  List<Object> get props => [message];
}

/// Стейт загрузки
class LoadingState extends {{screen_name.pascalCase()}}State {
  const LoadingState();
  
  @override
  List<Object> get props => [];
}
