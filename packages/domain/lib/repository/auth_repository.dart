import 'package:dartz/dartz.dart';
import 'package:domain/core/failure/failure.dart';
import 'package:domain/entity/request/sign_in_request.dart';
import 'package:domain/entity/response/sign_in_response.dart';

/// Репозиторий для работы с авторизацией
abstract interface class AuthRepository {
  /// Авторизация
  Future<Either<Failure, SignInResponse>> signIn(SignInRequest signInData);
}
