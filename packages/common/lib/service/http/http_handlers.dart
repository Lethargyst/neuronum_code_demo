part of 'http_unauth.dart';

Either<FailureApi, ApiResponse> _responseHandler(
  Response<dynamic> response,
  REQUEST_TYPE request, [
  dynamic query,
]) {
  final data = response.data;
  final statusCode = response.statusCode ?? 0;
  final apiResponse = ApiResponse(
    data: response.data,
    headers: response.headers.map,
  );
  
  return Either.cond(
    () => statusCode >= 200 && statusCode <= 299,
    () => apiResponse,
    () {
      try {
        return FailureApi(
          (data as Map<String, dynamic>)['details']?.toString() ?? t.errors.somethingWentWrong,
          statusCode: statusCode,
          requestType: request,
          query: query,
          requestPath: response.requestOptions.path,
        );
      } catch (_) {
        return FailureApi(
          t.errors.somethingWentWrong,
          statusCode: statusCode, 
          requestType: request, 
          query: query,
        );
      }
    },
  );
}

Either<FailureApi, ApiResponse> _errorHandler(
  DioException err,
  REQUEST_TYPE request, [
  dynamic query,
]) {
  if (err.type == DioExceptionType.unknown || err.type == DioExceptionType.connectionError) {
    return Left(
      FailureApi(
        t.errors.noConnection,
        statusCode: err.response?.statusCode,
        requestType: request,
        query: query,
      ),
    );
  }
  return Left(
    FailureApi(
      err.toString(),
      statusCode: err.response?.statusCode,
      requestType: request,
      stackTrace: StackTrace.current,
      query: query,
    ),
  );
}
