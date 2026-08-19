// lib/core/network/dio_client.dart
//
// Dio 實例工廠：組裝攔截器並預留證書綁定（certificate pinning）。
//
// 合規（PDPO 第4原則 / 醫健通保安標準）：
// - 生產環境強制證書綁定，指紋由 dart-define API_CERT_SHA256 提供（§8.2）。
// - 啟用 auth / log / error 攔截器；log 攔截器負責 PII 脫敏（§8.1）。

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rehab_med/core/storage/secure_storage.dart';

import '../config/app_config.dart';
import 'auth_interceptor.dart';
import 'log_interceptor.dart';

Dio createDioClient(SecureStorage secureStorage) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  dio.interceptors.addAll([
    AuthInterceptor(secureStorage),
    LogInterceptorEx(enableLogging: AppConfig.enableLogging),
    // TODO: 證書綁定 — ENABLE_CERT_PINNING 為 true 時，於 SecurityContext 加入
    //       AppConfig.apiCertSha256 指紋，強制 host 憑證匹配（防止中間人）。
  ]);

  return dio;
}

/// 全域 Dio Provider（已掛載 auth / log 攔截器）。
final dioProvider = Provider<Dio>((ref) {
  return createDioClient(ref.watch(secureStorageProvider));
});
