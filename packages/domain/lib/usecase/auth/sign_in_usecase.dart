import 'package:dartz/dartz.dart';
import 'package:domain/core/failure/failure.dart';
import 'package:domain/entity/request/sign_in_request.dart';
import 'package:domain/repository/auth_repository.dart';
import 'package:domain/storage/auth_data_storage.dart';
import 'package:domain/storage/user_storage.dart';
import 'package:injectable/injectable.dart';

/// Юзкейс авторизации
@injectable
class SignInUsecase {
  final AuthRepository _repository;
  final UserStorage _userStorage;
  final AuthDataStorage _authStorage;

  const SignInUsecase(this._repository, this._userStorage, this._authStorage);

  Future<Either<Failure, bool>> call(SignInRequest signInData) async {
    final result = await _repository.signIn(signInData);
    return result.fold(
      Left.new,
      (r) async {
        final savedAuth = await _authStorage.saveAuthData(r.authData);
        if (!savedAuth) return Left(FailureUnknown("Не удалось сохранить данные авторизации"));

        final savedUser = await _userStorage.setUser(r.user);
        if (!savedUser) return Left(FailureUnknown("Не удалось сохранить пользователя"));
        
        return const Right(true);
      },
    );
  }
}
