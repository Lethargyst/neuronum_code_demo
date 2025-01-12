part of 'calls_bloc.dart';

sealed class CallsState extends Equatable {
  const CallsState();
}

/// Стейт успеха
class SuccessState extends CallsState {
  final List<Call> items;
  final int totalItemsCount;
  final bool isPaginating;
  final int? nextPage;
  final String? paginationError;

  const SuccessState({
    required this.items,
    required this.nextPage,
    this.totalItemsCount = 0, 
    this.isPaginating = false,
    this.paginationError,
  });

  @override
  List<Object> get props => [
    items,
    items.hashCode,
    isPaginating,
    if (nextPage != null) nextPage!,
    if (paginationError != null) paginationError!,
  ];

  SuccessState copyWith({
    List<Call>? items,
    bool? isPaginating,
    int? nextPage,
    int? totalItemsCount,
    String? paginationError,
  }) => SuccessState(
    items: items ?? this.items,
    totalItemsCount: totalItemsCount ?? this.totalItemsCount,
    isPaginating: isPaginating ?? this.isPaginating,
    nextPage: nextPage ?? this.nextPage,
    paginationError: paginationError ?? this.paginationError,
  );
}

/// Стейт ошибки
class FailureState extends CallsState {
  final String message;

  const FailureState(this.message);
  
  @override
  List<Object> get props => [message];
}

/// Стейт загрузки
class LoadingState extends CallsState {
  const LoadingState();
  
  @override
  List<Object> get props => [];
}
