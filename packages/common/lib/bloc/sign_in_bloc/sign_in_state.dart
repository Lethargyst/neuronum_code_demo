part of 'sign_in_bloc.dart';

sealed class SignInState extends Equatable {
  const SignInState();
}

/// Стейт успеха логина
class SuccessState extends SignInState {
  const SuccessState();

  @override
  List<Object> get props => [];
}

/// Стейт ошибки логина
class FailureState extends SignInState {
  final String message;

  const FailureState(this.message);
  
  @override
  List<Object> get props => [message];
}

/// Стейт загрузки логина
class LoadingState extends SignInState {
  const LoadingState();
  
  @override
  List<Object> get props => [];
}