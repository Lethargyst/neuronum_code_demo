part of 'onlyoffice_bloc.dart';

sealed class OnlyofficeEvent extends Equatable {
  const OnlyofficeEvent();
}

/// Получить конфиг онлиофиса
class GetConfigEvent extends OnlyofficeEvent {
  final DateTime startDate;
  final DateTime endDate;

  const GetConfigEvent({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [startDate, endDate];
}