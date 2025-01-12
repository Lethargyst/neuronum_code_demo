import 'package:common/gen/translations.g.dart';
import 'package:core/service/logger/logger.dart';
import 'package:dartz/dartz.dart';
import 'package:data/api/auth_api.dart';
import 'package:domain/core/failure/failure.dart';
import 'package:data/dto/request/sign_in/sign_in_request_dto.dart';
import 'package:data/dto/response/sign_in/sign_in_response_dto.dart';
import 'package:domain/entity/request/sign_in_request.dart';
import 'package:domain/entity/response/sign_in_response.dart';
import 'package:domain/repository/auth_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthApi _api;
  final AppLogger _logger;

  const AuthRepositoryImpl(this._api, this._logger);

  @override
  Future<Either<Failure, SignInResponse>> signIn(SignInRequest signInData) async {
    final body = SignInRequestDto.fromEntity(signInData).toJson();
    final response = await _api.signIn(body);
    return response.fold(
      (l) {
        final failure = (l as FailureApi).handleMessage(
          {
            400 : t.auth.invalidCredentials,
            422 : t.auth.wrongCredentials,
          },
        );
        _logger.api(message: failure.message, stackTrace: l.stackTrace);
        return Left(failure);
      },
      (r) {
        try {
          final dto = SignInResponseDto.fromJson(r.data as Map<String, dynamic>);
          final entity = dto.toEntity();

          return Right(entity);
        } catch (err, trc) {
          _logger.parsing(stackTrace: trc, message: err.toString());
          return Left(FailureParsing(err.toString()));
        }
      },
    );
  }
}
