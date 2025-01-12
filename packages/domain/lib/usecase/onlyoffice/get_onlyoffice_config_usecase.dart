import 'package:dartz/dartz.dart';
import 'package:domain/core/failure/failure.dart';
import 'package:domain/repository/onlyoffice_repository.dart';
import 'package:domain/utils/extensions/date_time_extension.dart';
import 'package:injectable/injectable.dart';

/// Юзкейс для получения конфига онилофиса
@injectable
class GetOnlyofficeConfigUsecase {
  final OnlyofficeRepository _repository;

  const GetOnlyofficeConfigUsecase(this._repository);

  Future<Either<Failure, Map<String, dynamic>>> call({
    required String projectId, 
    required DateTime startDate, 
    required DateTime endDate,
  }) =>
     _repository.getConfig(
      projectId, 
      startDate.formattedDateString, 
      endDate.formattedDateString,
    );
}
