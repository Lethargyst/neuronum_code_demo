import 'package:dartz/dartz.dart';
import 'package:domain/core/failure/failure.dart';
import 'package:domain/entity/common/call/call.dart';
import 'package:domain/entity/common/file.dart';
import 'package:domain/entity/common/filter.dart';
import 'package:domain/entity/time_range/time_range.dart';

/// Репозиторий для работы со звонками
abstract interface class CallsRepository {
  /// Получить звонки
  Future<Either<Failure, (int, List<Call>)>> getCalls({
    required String projectId, 
    required List<FilterEntity> filters,
    required TimeRange interval,
    required int page,
    required int pageSize,
  });

  /// Получить запись звонка
  Future<Either<Failure, FileEntity>> getCallRecord(
    String projectId, 
    String callId,
  );

  /// Сохранить звонок в формате mp3
  Future<Either<Failure, bool>> saveCallRecord(FileEntity record);

  /// Редактировать комментарий к звонку
  Future<Either<Failure, bool>> editComment(String projectId, String callId, String message);

  /// Удалить комментарий к звонку
  Future<Either<Failure, bool>> deleteComment(String projectId, String callId);
}
