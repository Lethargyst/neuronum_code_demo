// Package imports:
import 'package:common/di/di.dart';
import 'package:domain/di/di.dart';
import 'package:get_it/get_it.dart';
import 'package:data/di/di.dart';
import 'package:core/di/di.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'di.config.dart';

final getIt = GetIt.instance;

@InjectableInit(preferRelativeImports: false)
void configureDependencies() {
  getIt.init();
}

void configureDI() {
  configureDependencies();
  configureDomain();
  configureData();
  configureCore();
  configureCommon();
}
