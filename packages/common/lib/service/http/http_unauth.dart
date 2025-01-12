import 'package:common/gen/translations.g.dart';
import 'package:core/app_config.dart';
import 'package:core/service/http/base_http.dart';
import 'package:core/service/http/http_unauth.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:domain/core/failure/failure.dart';
import 'package:injectable/injectable.dart';

part 'http_handlers.dart';

@Singleton(as: HttpUnauth)
class HttpUnauthImpl implements HttpUnauth {
  final _dio = Dio(BaseOptions(baseUrl: AppConfig().domain));

  @override
  Future<Either<Failure, ApiResponse>> get({
    required String uri,
    bool bytesResponse = false,
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? extraHeaders,
  }) async {
    try {
      final response = await _dio.get<dynamic>(
        uri,
        data: body,
        queryParameters: queryParameters,
        options: Options(
          headers: extraHeaders,
          responseType: bytesResponse ? ResponseType.bytes : null,
        ),
      );
      return _responseHandler(response, REQUEST_TYPE.GET, queryParameters);
    } on DioException catch (err) {
      return _errorHandler(err, REQUEST_TYPE.GET, queryParameters);
    } catch (err, str) {
      return Left(FailureUnknown(err.toString(), stackTrace: str));
    }
  }

  @override
  Future<Either<Failure, ApiResponse>> post({
    required String uri,
    bool bytesResponse = false,
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? extraHeaders,
  }) async {
    try {
      final response = await _dio.post<dynamic>(
        uri,
        data: body,
        queryParameters: queryParameters,
        options: Options(
          headers: {
            if (extraHeaders != null)
              ...extraHeaders,
            'Content-Type': 'application/json',
          },
          responseType: bytesResponse ? ResponseType.bytes : null,
        ),
      );
      return _responseHandler(response, REQUEST_TYPE.POST, body);
    } on DioException catch (err) {
      return _errorHandler(err, REQUEST_TYPE.POST, body);
    } catch (err, str) {
      return Left(FailureUnknown(err.toString(), stackTrace: str));
    }
  }

  @override
  Future<Either<Failure, ApiResponse>> put({
    required String uri,
    dynamic body,
    Map<String, dynamic>? extraHeaders,
  }) async {
    try {
      final response = await _dio.put<dynamic>(
        uri,
        data: body,
        options: Options(headers: extraHeaders),
      );
      return _responseHandler(response, REQUEST_TYPE.PUT, body);
    } on DioException catch (err) {
      return _errorHandler(err, REQUEST_TYPE.PUT, body);
    } catch (err, str) {
      return Left(FailureUnknown(err.toString(), stackTrace: str));
    }
  }

  @override
  Future<Either<Failure, ApiResponse>> delete({
    required String uri,
    dynamic body,
    Map<String, dynamic>? extraHeaders,
  }) async {
    try {
      final response = await _dio.delete<dynamic>(
        uri,
        data: body,
        options: Options(
          headers: {
            if (extraHeaders != null)
              ...extraHeaders,
            'Content-Type': 'application/json',
          },
        ),
      );
      return _responseHandler(response, REQUEST_TYPE.DELETE, body);
    } on DioException catch (err) {
      return _errorHandler(err, REQUEST_TYPE.DELETE, body);
    } catch (err, str) {
      return Left(FailureUnknown(err.toString(), stackTrace: str));
    }
  }

  @override
  Future<Either<Failure, ApiResponse>> postSingleFile({
    required String uri,
    required List<int> file,
    required String fileName,
    required String parameterName,
    Map<String, dynamic>? extraHeaders,
  }) async {
    try {
      final bodyFile = MultipartFile.fromBytes(file, filename: fileName);
      final formData = FormData.fromMap({parameterName: bodyFile});
      final headers = extraHeaders ?? <String, dynamic>{};
      headers.addAll({
        Headers.contentLengthHeader: file.length,
        Headers.contentTypeHeader: "multipart/form-data",
      });

      final response = await _dio.post<dynamic>(
        uri,
        data: formData,
        options: Options(headers: headers),
      );
      return _responseHandler(response, REQUEST_TYPE.POST_SINGLE_FILE);
    } on DioException catch (err) {
      return _errorHandler(err, REQUEST_TYPE.POST_SINGLE_FILE);
    } catch (err, str) {
      return Left(FailureUnknown(err.toString(), stackTrace: str));
    }
  }
}
