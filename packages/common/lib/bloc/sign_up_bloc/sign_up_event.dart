part of 'sign_up_bloc.dart';

sealed class SignUpEvent extends Equatable {
  const SignUpEvent();
}

/// Описание ивента
class ExampleEvent extends SignUpEvent {
  @override
  List<Object?> get props => [];
}