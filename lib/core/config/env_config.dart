class EnvConfig {
  // API接続先（flutter build web --dart-define=API_BASE_URL=... で切り替え可能）
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8000',
  );
  // WebSocket接続先（flutter build web --dart-define=WS_BASE_URL=... で切り替え可能）
  static const String wsBaseUrl = String.fromEnvironment(
    'WS_BASE_URL',
    defaultValue: 'ws://localhost:8000',
  );
  // モック用
  static const bool useMock = false;
  // ローカル環境かどうかを判定（ws://localhost で始まれば true）
  static bool get isLocal => wsBaseUrl.startsWith('ws://localhost');
}
