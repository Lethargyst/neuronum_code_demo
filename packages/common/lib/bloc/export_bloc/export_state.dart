part of 'export_bloc.dart';

sealed class ExportState extends Equatable {
  const ExportState();
}

/// Стейт успеха
class SuccessState extends ExportState {
  const SuccessState();

  @override
  List<Object> get props => [];
}

/// Стейт ошибки
class FailureState extends ExportState {
  final String message;

  const FailureState(this.message);
  
  @override
  List<Object> get props => [message];
}

/// Стейт загрузки
class LoadingState extends ExportState {
  const LoadingState();
  
  @override
  List<Object> get props => [];
}
