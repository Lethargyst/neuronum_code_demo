import 'dart:convert';
import 'dart:typed_data';

import 'package:common/utils/parsers.dart';
import 'package:core/service/logger/logger.dart';
import 'package:dartz/dartz.dart';
import 'package:data/api/calls_api.dart';
import 'package:data/dto/common/call/call_dto.dart';
import 'package:data/dto/common/filter/filter_dto.dart';
import 'package:data/dto/common/time_interval/time_interval_dto.dart';
import 'package:domain/core/failure/failure.dart';
import 'package:domain/entity/common/call/call.dart';
import 'package:domain/entity/common/file.dart';
import 'package:domain/entity/common/filter.dart';
import 'package:domain/entity/time_range/time_range.dart';
import 'package:domain/repository/calls_repository.dart';
import 'package:domain/storage/user_storage.dart';
import 'package:injectable/injectable.dart';
// ignore: depend_on_referenced_packages
import 'package:web/web.dart';


@Injectable(as: CallsRepository)
class CallsRepositoryImpl implements CallsRepository {
  final CallsApi _api;
  final UserStorage _userStorage;
  final AppLogger _logger;

  const CallsRepositoryImpl(this._api, this._userStorage, this._logger);

  @override
  Future<Either<Failure, (int, List<Call>)>> getCalls({
    required String projectId,
    required List<FilterEntity> filters,
    required TimeRange interval,
    required int page,
    required int pageSize,
  }) async {
    final body = {
      'filters': filters.toJson(),
      ...interval.toJson(),
    };
    final response = await _api.getCalls(
      body: body,
      projectId: projectId,
      pageSize: pageSize,
      pageNumber: page,
    );
    return response.fold(
      (l) {
        _logger.api(message: l.message, stackTrace: l.stackTrace);
        return Left(l);
      },
      (r) {
        try {
          final data = r.data as Map<String, dynamic>;
          final callsData = data['calls'] as List<dynamic>;
          final totalCalls = (data['pageMetadata'] as Map<String, dynamic>)['totalCalls'] as int;

          final dtos = CallDto.fromJsonList(callsData);
          final entities = dtos.toEntity();
          
          return Right((totalCalls, entities));
        } catch (err, trc) {
          _logger.parsing(stackTrace: trc, message: err.toString());
          return Left(FailureParsing(err.toString()));
        }
      },
    );
  }

  @override
  Future<Either<Failure, FileEntity>> getCallRecord(
    String projectId, 
    String callId,
  ) async {
    final response = await _api.getCallRecord(projectId, callId);
    return response.fold(
      (l) {
        _logger.api(message: l.message, stackTrace: l.stackTrace);
        return Left(l);
      },
      (r) {
        try {
          final content = Uint8List.fromList(r.data as List<int>);
          final filename = parseFileNameFromHeader(r.headers);
          final result = FileEntity(name: filename ?? '$callId.mp3', content: content);

          return Right(result);
        } catch (err, trc) {
          _logger.parsing(stackTrace: trc, message: err.toString());
          return Left(FailureParsing(err.toString()));
        }
      },
    );
  }

  @override
  Future<Either<Failure, bool>> saveCallRecord(FileEntity record) async {
    try {
      final content = base64.encode(record.content);

      HTMLAnchorElement()
        ..href = "data:application/octet-stream;charset=utf-16le;base64,$content"
        ..setAttribute('download', record.name)
        ..click();

      return const Right(true);
    } catch (err, trc) {
      _logger.unknown(message: err.toString(), stackTrace: trc);
      return Left(FailureUnknown(err.toString(), stackTrace: trc));
    }
  }

  @override
  Future<Either<Failure, bool>> editComment(String projectId, String callId, String comment) async {
    final userId = _userStorage.user?.id;
    if (userId == null) {
      _logger.unknown(message: 'Ошибка авторизации', stackTrace: StackTrace.current);
      return Left(FailureUnauth());
    }

    final response = await _api.editComment(
      projectId: projectId, 
      callId: callId,
      userId: userId,
      comment: comment,
    );
    return response.fold(       
      (l) {
        _logger.api(message: l.message, stackTrace: l.stackTrace);
        return Left(l);
      },
      (r) => const Right(true),
    );
  }
  
  @override
  Future<Either<Failure, bool>> deleteComment(String projectId, String callId) async {
    final userId = _userStorage.user?.id;
    if (userId == null) {
      _logger.unknown(message: 'Ошибка авторизации', stackTrace: StackTrace.current);
      return Left(FailureUnauth());
    }

    final response = await _api.deleteComment(
      projectId: projectId, 
      callId: callId,
      userId: userId,
    );
    return response.fold(       
      (l) {
        _logger.api(message: l.message, stackTrace: l.stackTrace);
        return Left(l);
      },
      (r) => const Right(true),
    );
  }
}
