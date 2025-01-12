part of 'onlyoffice_bloc.dart';

sealed class OnlyofficeState extends Equatable {
  const OnlyofficeState();
}

/// Стейт успеха
class SuccessState extends OnlyofficeState {
  final Map<String, dynamic> config;
  
  const SuccessState({required this.config});

  @override
  List<Object> get props => [config];
}

/// Стейт ошибки
class FailureState extends OnlyofficeState {
  final String message;

  const FailureState(this.message);
  
  @override
  List<Object> get props => [message];
}

/// Стейт загрузки
class LoadingState extends OnlyofficeState {
  const LoadingState();
  
  @override
  List<Object> get props => [];
}
