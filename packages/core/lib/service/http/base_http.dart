import 'package:dartz/dartz.dart';
import 'package:domain/core/failure/failure.dart';

/// Класс с ответом с сервера
final class ApiResponse {
  final dynamic data;
  final Map<String, dynamic>? headers;

  const ApiResponse({this.data, this.headers});
}

abstract class BaseHttp {
  /// GET-запрос
  Future<Either<Failure, ApiResponse>> get({
    required String uri,
    bool bytesResponse,
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? extraHeaders,
  });

  /// POST-запрос
  Future<Either<Failure, ApiResponse>> post({
    required String uri,
    bool bytesResponse,
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? extraHeaders,
  });

  /// PUT-запрос
  Future<Either<Failure, ApiResponse>> put({
    required String uri,
    dynamic body,
    Map<String, dynamic>? extraHeaders,
  });

  /// DELETE-запрос
  Future<Either<Failure, ApiResponse>> delete({
    required String uri,
    dynamic body,
    Map<String, dynamic>? extraHeaders,
  });

  /// Загрузить файл на сервер
  Future<Either<Failure, ApiResponse>> postSingleFile({
    required String uri,
    required List<int> file,
    required String fileName,
    required String parameterName,
    Map<String, dynamic>? extraHeaders,
  });
}