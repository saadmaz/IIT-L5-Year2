// File: frontend/lib/config/env_config.dart

enum Environment {
  dev,
  prod,
  test,
}

class EnvConfig {
  final String apiBaseUrl;
  final bool enableLogging;
  final String appName;

  static Environment _environment = Environment.dev;

  // Singleton pattern
  static final EnvConfig _instance = EnvConfig._internal();

  factory EnvConfig() {
    return _instance;
  }

  EnvConfig._internal()
      : apiBaseUrl = _getApiBaseUrl(_environment),
        enableLogging = _getEnableLogging(_environment),
        appName = _getAppName(_environment);

  static String _getApiBaseUrl(Environment env) {
    switch (env) {
      case Environment.dev:
        return 'http://localhost:3000/api';
      case Environment.prod:
        return 'https://api.physioconnect.com/api';
      case Environment.test:
        return 'http://localhost:3000/api';
    }
  }

  static bool _getEnableLogging(Environment env) {
    switch (env) {
      case Environment.dev:
        return true;
      case Environment.prod:
        return false;
      case Environment.test:
        return true;
    }
  }

  static String _getAppName(Environment env) {
    switch (env) {
      case Environment.dev:
        return 'PhysioConnect EHPR (Dev)';
      case Environment.prod:
        return 'PhysioConnect EHPR';
      case Environment.test:
        return 'PhysioConnect EHPR (Test)';
    }
  }

  static void setEnvironment(Environment env) {
    _environment = env;
  }
}
