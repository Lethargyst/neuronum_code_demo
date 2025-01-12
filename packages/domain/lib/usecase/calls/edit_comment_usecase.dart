import 'package:dartz/dartz.dart';
import 'package:domain/core/failure/failure.dart';
import 'package:domain/repository/calls_repository.dart';
import 'package:injectable/injectable.dart';

/// Юзкейс для редактирования комментария к звонку
@injectable
class EditCommentUsecase {
  final CallsRepository _repository;

  const EditCommentUsecase(this._repository);

  Future<Either<Failure, bool>> call({
    required String projectId, 
    required String callId, 
    required String comment,
  }) =>
     _repository.editComment(projectId, callId, comment);
}
