part 'env.dart';

class AppConfig {
  static final _instance = AppConfig._();

  factory AppConfig() => _instance;

  AppConfig._();

  late final _Env _env;

  void init(String env) {
    _env = switch (env) {
      "dev" => _EnvDev(),
      String() => _EnvDev(),
    };
  }

  String get domain => _env.domain;
  String get onlyOfficeDomain => _env.domain.replaceFirst('/api', '');
}
