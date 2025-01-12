import 'package:core/service/http/base_http.dart';
import 'package:dartz/dartz.dart';
import 'package:domain/core/failure/failure.dart';

typedef IntCallback = void Function(int value);

typedef StringCallback = void Function(String value);

typedef BoolCallback = void Function(bool value);

typedef BoolFunction = bool Function();

typedef ApiRequest = Future<Either<Failure, ApiResponse>>;

typedef Json = Map<String, dynamic>;
