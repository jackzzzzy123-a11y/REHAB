// lib/core/config/app_config.dart
//
// 環境設定統一讀取入口（§8.2）。
// 所有變數經 --dart-define 注入，不提交 .env 檔。
//
// 合規：API 端點位於香港；禁止任意改為境外網址（不跨境傳輸）。

class AppConfig {
  AppConfig._();

  static late final String apiBaseUrl;
  static late final String apiCertSha256;
  static late final bool enableCertPinning;
  static late final bool enableLogging;

  static void init() {
    apiBaseUrl = const String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'https://api.rehabmed.hk/',
    );
    apiCertSha256 = const String.fromEnvironment('API_CERT_SHA256');
    enableCertPinning = const bool.fromEnvironment('ENABLE_CERT_PINNING');
    enableLogging = const bool.fromEnvironment(
      'ENABLE_LOGGING',
      defaultValue: true,
    );
  }
}
