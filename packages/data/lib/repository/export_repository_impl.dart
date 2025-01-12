import 'dart:convert';

import 'package:core/service/logger/logger.dart';
import 'package:common/utils/parsers.dart';
import 'package:dartz/dartz.dart';
import 'package:data/api/export_api.dart';
import 'package:data/dto/common/filter/filter_dto.dart';
import 'package:data/dto/common/time_interval/time_interval_dto.dart';
import 'package:domain/core/failure/failure.dart';
import 'package:domain/entity/common/filter.dart';
import 'package:domain/entity/time_range/time_range.dart';
import 'package:domain/repository/export_repository.dart';
import 'package:injectable/injectable.dart';
// ignore: depend_on_referenced_packages
import 'package:web/web.dart';

@Injectable(as: ExportRepository)
class ExportRepositoryImpl implements ExportRepository {
  final ExportApi _api;
  final AppLogger _logger;

  const ExportRepositoryImpl(this._api, this._logger);

  @override
  Future<Either<Failure, bool>> downloadExcel({
    required String projectId, 
    required List<FilterEntity> filters,
    required TimeRange interval,
  }) async {
    final body = {
      'filters': filters.toJson(),
      ...interval.toJson(),
    };
    final response = await _api.downloadExcel(projectId: projectId, body: body);
    return response.fold(
      (l) {
        _logger.api(message: l.message, stackTrace: l.stackTrace);
        return Left(l);
      },
      (r) {
        try {
          final data = base64.encode(r.data as List<int>);
          final filename = parseFileNameFromHeader(r.headers);
          
          HTMLAnchorElement()
            ..href = "data:application/octet-stream;charset=utf-16le;base64,$data"
            ..setAttribute('download', filename ?? '$projectId.xlsx')
            ..click();

          return const Right(true);
        } catch (err, trc) {
          _logger.parsing(stackTrace: trc, message: err.toString());
          return Left(FailureParsing(err.toString()));
        }
      },
    );
  }

  @override
  Future<Either<Failure, bool>> downloadCsv({
    required String projectId, 
    required List<FilterEntity> filters,
    required TimeRange interval,
  }) async {
    final body = {
      'filters': filters.toJson(),
      ...interval.toJson(),
    };
    final response = await _api.downloadCsv(projectId: projectId, body: body);
    return response.fold(
      (l) {
        _logger.api(message: l.message, stackTrace: l.stackTrace);
        return Left(l);
      },
      (r) {
        try {
          final data = base64.encode(r.data as List<int>);
          final filename = parseFileNameFromHeader(r.headers);

          HTMLAnchorElement() 
            ..href = 'data:application/octet-stream;charset=utf-16le;base64,$data'
            ..setAttribute('download', filename ?? projectId)
            ..click();

          return const Right(true);
        } catch (err, trc) {
          _logger.parsing(stackTrace: trc, message: err.toString());
          return Left(FailureParsing(err.toString()));
        }
      },
    );
  }
}
