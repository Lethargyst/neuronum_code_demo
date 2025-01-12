import 'package:dartz/dartz.dart';
import 'package:domain/core/failure/failure.dart';
import 'package:domain/repository/calls_repository.dart';
import 'package:injectable/injectable.dart';

/// Юзкейс для удаления комментария к звонку
@injectable
class DeleteCommentUsecase {
  final CallsRepository _repository;

  const DeleteCommentUsecase(this._repository);

  Future<Either<Failure, bool>> call({
    required String projectId, 
    required String callId, 
  }) =>
     _repository.deleteComment(projectId, callId);
}
