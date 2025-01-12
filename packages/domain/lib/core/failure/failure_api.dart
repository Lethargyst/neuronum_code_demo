// ignore_for_file: camel_case_types
// ignore_for_file: constant_identifier_names

part of 'failure.dart';

enum REQUEST_TYPE { GET, POST, PUT, DELETE, POST_SINGLE_FILE }

/// Ошибка связанная с бэком
class FailureApi extends Failure {
  /// Код ошибки
  final int? statusCode;

  /// Текст ошибки
  final List<String>? bodyText;

  /// Запрос, на который выбило ошибку
  final String? requestPath;

  /// Тип реквеста, на который выбило ошибку
  final REQUEST_TYPE requestType;

  /// Параметры, которые были переданы в запросе
  final dynamic query;

  /// Доп данные ошибки, переданные с сервера
  final Map<String, dynamic>? data;

  FailureApi(
    super.message, {
    required this.requestType,
    this.statusCode,
    super.stackTrace,
    this.bodyText,
    this.requestPath,
    this.query,
    this.data,
  });

  FailureApi handleMessage(Map<int, String> codeMessages) => FailureApi(
    codeMessages[statusCode] ?? message, 
    requestType: requestType,
    stackTrace: stackTrace,
    statusCode: statusCode,
    bodyText: bodyText,
    requestPath: requestPath,
    query: query,
    data: data,
  );

  @override
  String toString() => super.message;
}
