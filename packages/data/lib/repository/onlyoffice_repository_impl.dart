import 'package:core/service/logger/logger.dart';
import 'package:dartz/dartz.dart';
import 'package:data/api/onlyoffice_api.dart';
import 'package:domain/core/failure/failure.dart';
import 'package:domain/repository/onlyoffice_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: OnlyofficeRepository)
class OnlyofficeRepositoryImpl implements OnlyofficeRepository {
  final OnlyofficeApi _api;
  final AppLogger _logger;

  const OnlyofficeRepositoryImpl(this._api, this._logger);

  @override
  Future<Either<Failure, Map<String, dynamic>>> getConfig(
    String projectId, 
    String startDate, 
    String endDate,
  ) async {
    final response = await _api.getConfig(projectId, startDate, endDate);
    return response.fold(
      (l) {
        _logger.api(message: l.message, stackTrace: l.stackTrace);
        return Left(l);
      },
      (r) {
        final data = r.data as Map<String, dynamic>;
        return Right(data); 
      }
    );
  }
}
