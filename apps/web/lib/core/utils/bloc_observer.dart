// ignore_for_file: avoid_dynamic_calls
import 'package:core/service/logger/logger.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

class AppBlocObserver extends BlocObserver {
  List<BlocBase<dynamic>> openedBlocs = [];

  @override
  void onCreate(BlocBase<dynamic> bloc) {
    super.onCreate(bloc);
    openedBlocs.add(bloc);
    GetIt.I<AppLogger>().info(
      message: "\x1B[94mСоздан\x1B[0m BLoC \x1B[32m${bloc.runtimeType}\x1B[0m, открыто: ${openedBlocs.length}",
    );
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    super.onClose(bloc);
    openedBlocs.remove(openedBlocs.firstWhere((element) => element == bloc));
    GetIt.I<AppLogger>().info(
      message: "\x1B[91mЗакрыт\x1B[0m BLoC \x1B[32m${bloc.runtimeType}\x1B[0m, открыто: ${openedBlocs.length}",
    );
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    Logger().e(
      "Ошибка BLoC \x1B[32m${bloc.runtimeType}\x1B[0m: $error",
      stackTrace: stackTrace,
      error: error,
    );
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    GetIt.I<AppLogger>().info(
      message: "Изменён message: BLoC \x1B[32m${bloc.runtimeType}\x1B[0m: \x1B[37m${change.currentState.runtimeType}\x1B[0m => \x1B[95m${change.nextState.runtimeType}\x1B[0m",
    );
  }

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    GetIt.I<AppLogger>().info(
      message: "\x1B[96mВызвано событие\x1B[0m BLoC \x1B[32m${bloc.runtimeType}\x1B[0m: \x1B[36m${event.runtimeType}\x1B[0m",
    );
  }
}
