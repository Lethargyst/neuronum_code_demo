part of 'sign_up_bloc.dart';

sealed class SignUpState extends Equatable {
  const SignUpState();
}

/// Стейт успеха
class SuccessState extends SignUpState {
  const SuccessState();

  @override
  List<Object> get props => [];
}

/// Стейт ошибки
class FailureState extends SignUpState {
  final String message;

  const FailureState(this.message);
  
  @override
  List<Object> get props => [message];
}

/// Стейт загрузки
class LoadingState extends SignUpState {
  const LoadingState();
  
  @override
  List<Object> get props => [];
}
