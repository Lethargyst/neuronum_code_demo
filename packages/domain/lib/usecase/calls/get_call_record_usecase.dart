import 'package:dartz/dartz.dart';
import 'package:domain/core/failure/failure.dart';
import 'package:domain/entity/common/file.dart';
import 'package:domain/repository/calls_repository.dart';
import 'package:injectable/injectable.dart';

/// Юзкейс получения записи звонка
@injectable
class GetCallRecordUsecase {
  final CallsRepository _repository;

  const GetCallRecordUsecase(this._repository);

  Future<Either<Failure, FileEntity>> call(String projectId, String callId) =>
     _repository.getCallRecord(projectId, callId);
}
