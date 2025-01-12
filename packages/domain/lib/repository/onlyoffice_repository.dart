import 'package:dartz/dartz.dart';
import 'package:domain/core/failure/failure.dart';

/// Репозиторий для работы с редактором таблицы на онлиоффисе
abstract interface class OnlyofficeRepository {
  /// Получить конфин для html'ки онлиоффиса
  Future<Either<Failure, Map<String, dynamic>>> getConfig(
    String projectId, 
    String startDate, 
    String endDate,
  );
}
