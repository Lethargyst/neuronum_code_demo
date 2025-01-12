import 'package:core/service/logger/logger.dart';
import 'package:dartz/dartz.dart';
import 'package:data/dto/common/user/user_dto.dart';
import 'package:domain/core/failure/failure.dart';
import 'package:domain/entity/common/user.dart';
import 'package:domain/service/cache/cache_client.dart';
import 'package:domain/service/cache/cache_client_secure.dart';
import 'package:domain/service/cache/manager/cache_user_manager.dart';
import 'package:injectable/injectable.dart';

/// Менеджер для кеширования пользователя
@Injectable(as: CacheUserManager)
class CacheUserManagerImpl extends CacheUserManager {
  final CacheClientSecure _cacheClientSecure;
  final AppLogger _logger;

  CacheUserManagerImpl(this._cacheClientSecure, this._logger);

  @override
  Future<Either<Failure, bool>> deleteUser() async => _cacheClientSecure.deleteData(StorageKey.user);

  @override
  Future<Either<Failure, User?>> loadUser() async {
    final result = await _cacheClientSecure.loadData(StorageKey.user);
    return result.fold(
      Left.new,
      (r) {
        try {
          final data = r as Map<String, dynamic>;
          return Right(data.isEmpty ? null : UserDto.fromJson(data).toEntity());          
        } catch (err, trc) {
          _logger.parsing(stackTrace: trc, error: err);
          return Left(FailureParsing(err.toString(), stackTrace: trc));
        }
      },
    );
  }

  @override
  Future<bool> saveUser(User user) async =>
      _cacheClientSecure.writeData(StorageKey.user, UserDto.fromEntity(user));
}
