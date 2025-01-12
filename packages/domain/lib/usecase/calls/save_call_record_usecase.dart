import 'package:dartz/dartz.dart';
import 'package:domain/core/failure/failure.dart';
import 'package:domain/entity/common/file.dart';
import 'package:domain/repository/calls_repository.dart';
import 'package:injectable/injectable.dart';

/// Юзкейс сохранения звонка в формате mp3
@injectable
class SaveCallRecordUsecase {
  final CallsRepository _repository;

  const SaveCallRecordUsecase(this._repository);

  Future<Either<Failure, bool>> call(FileEntity record) =>
    _repository.saveCallRecord(record);
}