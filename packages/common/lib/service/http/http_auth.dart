import 'package:common/gen/translations.g.dart';
import 'package:core/app_config.dart';
import 'package:core/service/http/base_http.dart';
import 'package:core/service/http/http_auth.dart';
import 'package:core/service/http/http_unauth.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:domain/core/failure/failure.dart';
import 'package:domain/entity/common/auth.dart';
import 'package:domain/storage/user_storage.dart';
import 'package:domain/storage/auth_data_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:mutex/mutex.dart';

@Singleton(as: HttpAuth)
class HttpAuthImpl implements HttpAuth {
  final AuthDataStorage _authStorage;
  final UserStorage _userStorage;
  final HttpUnauth _httpUnauth;

  HttpAuthImpl(this._authStorage, this._userStorage, this._httpUnauth);

  final _refreshDio = Dio(BaseOptions(baseUrl: AppConfig().domain));
  final _mutex = Mutex();

  @override
  Future<AuthData?> refreshJwtData([AuthData? oldAuth]) async {
    final authData = oldAuth ?? await _authStorage.getAuthData();
    if (authData == null) {
      return null;
    }

    if (authData.needAuth()) {
      await _authStorage.clearData();
      await _userStorage.setUser(null);
      return null;
    }

    try {
      final response = await _refreshDio.post<dynamic>(
        "/users/refresh",
        queryParameters: {
          "refreshToken": authData.refreshToken,
        },
      );
      if (response.statusCode == 200) {
        final newAuth = AuthData.fromJson(response.data as Map<String, dynamic>);
        await _authStorage.saveAuthData(newAuth);
        return newAuth;
      }
      await _authStorage.clearData();
      await _userStorage.setUser(null);
      return null;
    } catch (err) {
      await _authStorage.clearData();
      await _userStorage.setUser(null);
      return null;
    }
  }

  Future<Map<String, dynamic>?> _getAuthHeader([Map<String, dynamic>? initHeader]) async {
    final result = initHeader ?? <String, dynamic>{};

    final authHeader = await _authStorage.getAuthData();
    if (authHeader == null) {
      return null;
    }
    if (!authHeader.needRefresh()) {
      result.addAll(authHeader.header());
      return result;
    }

    final newAuth = await refreshJwtData();
    if (newAuth == null) {
      return null;
    }

    result.addAll(newAuth.header());
    return result;
  }

  Future<Either<Failure, ApiResponse>> _responseHandler(
    Either<Failure, ApiResponse> response,
  ) async {
    if (response.isRight()) return response;

    final failure = (response as Left).value as Failure;

    if (failure is! FailureApi) return response;
    if (failure.statusCode != 401) return response;
    if (failure.requestPath == null) return response;

    final authData = await _authStorage.getAuthData();
    if (authData == null) {
      return response;
    }

    final newAuth = await refreshJwtData(authData);
    if (newAuth == null) return response;

    final newResponse = switch (failure.requestType) {
      REQUEST_TYPE.GET => () => get(uri: failure.requestPath!, body: failure.query),
      REQUEST_TYPE.POST => () => post(uri: failure.requestPath!, body: failure.query),
      REQUEST_TYPE.PUT => () => put(uri: failure.requestPath!, body: failure.query),
      REQUEST_TYPE.DELETE => () => delete(uri: failure.requestPath!, body: failure.query),
      REQUEST_TYPE.POST_SINGLE_FILE => throw UnimplementedError()
    };
    return newResponse.call();
  }

  @override
  Future<Either<Failure, ApiResponse>> get({
    required String uri,
    bool bytesResponse = false,
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? extraHeaders,
  }) async {
    await _mutex.acquire();

    final header = await _getAuthHeader(extraHeaders);
    if (header == null) {
      _mutex.release();
      return Left(
        FailureApi(
          t.errors.noAuth,
          requestType: REQUEST_TYPE.GET,
          statusCode: 401,
          requestPath: uri,
          query: queryParameters,
        ),
      );
    }

    final result = _responseHandler(
      await _httpUnauth.get(
        uri: uri,
        body: body,
        queryParameters: queryParameters,
        extraHeaders: header,
        bytesResponse: bytesResponse,
      ),
    );
    _mutex.release();
    return result;
  }

  @override
  Future<Either<Failure, ApiResponse>> post({
    required String uri,
    bool bytesResponse = false,
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? extraHeaders,
  }) async {
    await _mutex.acquire();
    final header = await _getAuthHeader(extraHeaders);

    if (header == null) {
      _mutex.release();
      return Left(
        FailureApi(
          t.errors.noAuth,
          requestType: REQUEST_TYPE.POST,
          statusCode: 401,
          requestPath: uri,
          query: body,
        ),
      );
    }

    final result = _responseHandler(
      await _httpUnauth.post(
        uri: uri,
        body: body,
        queryParameters: queryParameters,
        extraHeaders: header,
        bytesResponse: bytesResponse,
      ),
    );
    _mutex.release();
    return result;
  }

  @override
  Future<Either<Failure, ApiResponse>> put({
    required String uri,
    dynamic body,
    Map<String, dynamic>? extraHeaders,
  }) async {
    await _mutex.acquire();
    final header = await _getAuthHeader(extraHeaders);

    if (header == null) {
      _mutex.release();
      return Left(
        FailureApi(
          t.errors.noAuth,
          requestType: REQUEST_TYPE.PUT,
          statusCode: 401,
          requestPath: uri,
          query: body,
        ),
      );
    }

    final result = _responseHandler(
      await _httpUnauth.put(
        uri: uri,
        body: body,
        extraHeaders: header,
      ),
    );
    _mutex.release();
    return result;
  }

  @override
  Future<Either<Failure, ApiResponse>> delete({
    required String uri,
    dynamic body,
    Map<String, dynamic>? extraHeaders,
  }) async {
    await _mutex.acquire();
    final header = await _getAuthHeader(extraHeaders);

    if (header == null) {
      _mutex.release();
      return Left(
        FailureApi(
          t.errors.noAuth,
          requestType: REQUEST_TYPE.DELETE,
          statusCode: 401,
          requestPath: uri,
          query: body,
        ),
      );
    }

    final result = _responseHandler(
      await _httpUnauth.delete(
        uri: uri,
        body: body,
        extraHeaders: header,
      ),
    );
    _mutex.release();
    return result;
  }

  @override
  Future<Either<Failure, ApiResponse>> postSingleFile({
    required String uri,
    required List<int> file,
    required String fileName,
    required String parameterName,
    Map<String, dynamic>? extraHeaders,
  }) async {
    await _mutex.acquire();
    final header = await _getAuthHeader(extraHeaders);

    if (header == null) {
      _mutex.release();
      return Left(
        FailureApi(
          t.errors.noAuth,
          requestType: REQUEST_TYPE.POST_SINGLE_FILE,
          statusCode: 401,
          requestPath: uri,
        ),
      );
    }

    final result = _responseHandler(
      await _httpUnauth.postSingleFile(
        uri: uri,
        file: file,
        fileName: fileName,
        parameterName: parameterName,
        extraHeaders: header,
      ),
    );
    _mutex.release();
    return result;
  }
}
