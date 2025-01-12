import 'package:domain/entity/common/user.dart';
import 'package:domain/storage/user_storage.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:lvm_telephony_web/core/service/router/router.dart';
import 'package:lvm_telephony_web/theme/theme_file.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _userStorage = GetIt.I<UserStorage>();
  final _router = RouterWebConfig();

  User? _user;

  @override
  void initState() {
    _user = _userStorage.user;
    _userStorage.logInStream.listen(_onLogin);
    _userStorage.logOutStream.listen(_onLogout);
    _userStorage.userChangedStream.listen(_onChange);
    super.initState();
  }

  void _onLogin(User? user) {
    _user = user;
    setState(() {});
  }

  Future<void> _onLogout(void _) async {
    _user = null;
    _router.navigate(const RootRoute());
    setState(() {});
  }

  void _onChange(User user) {
    _user = user;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    builder: (_, child) => Provider<User?>.value(value: _user, child: child),
    theme: appTheme,
    routerDelegate: _router.delegate(),
    routeInformationParser: _router.defaultRouteParser(),
    debugShowCheckedModeBanner: false,
    localizationsDelegates: [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [
      Locale('ru', 'RU'),
    ],
  );
}