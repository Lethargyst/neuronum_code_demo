import 'package:dartz/dartz.dart';
import 'package:domain/core/failure/failure.dart';
import 'package:domain/entity/common/user.dart';

abstract class CacheUserManager {
  Future<bool> saveUser(User user);

  Future<Either<Failure, User?>> loadUser();

  Future<Either<Failure, bool>> deleteUser();
}
