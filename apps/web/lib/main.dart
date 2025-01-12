import 'package:core/app_config.dart';
import 'package:domain/service/cache/cache_client.dart';
import 'package:domain/service/cache/cache_client_secure.dart';
import 'package:domain/storage/user_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lvm_telephony_web/app.dart';
import 'package:lvm_telephony_web/core/di/di.dart';
import 'package:lvm_telephony_web/core/utils/app_path_url_strategy.dart';
import 'package:lvm_telephony_web/core/utils/bloc_observer.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

Future<void> main() async {
  setUrlStrategy(AppPathUrlStrategy());
  WidgetsFlutterBinding.ensureInitialized();

  AppConfig().init('dev');
  configureDI();
  Bloc.observer = AppBlocObserver();

  await Future.wait([
    GetIt.I<UserStorage>().init(),
    GetIt.I<CacheClientSecure>().init(),
    GetIt.I<CacheClient>().init(),
  ]);

  runApp(const App());
}