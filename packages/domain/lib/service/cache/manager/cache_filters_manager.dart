import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:domain/core/failure/failure.dart';
import 'package:domain/entity/response/prop.dart';

abstract class CacheFiltersManager {
  FutureOr<bool> saveFilterValueSingle(Prop filter);

  FutureOr<bool> saveFilterValuesList(List<Prop> filters);

  Future<List<Prop>?> loadFiltersValues([List<String>? ids]);

  FutureOr<Either<Failure, bool>> deleteFilters();
}
