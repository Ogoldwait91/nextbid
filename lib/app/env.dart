class Env {
  static const String apiBase =
      String.fromEnvironment('API_BASE', defaultValue: 'http://127.0.0.1:8000');

  static const String month =
      String.fromEnvironment('BID_MONTH', defaultValue: '2025-11');
}
