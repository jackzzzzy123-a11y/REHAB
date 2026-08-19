// lib/core/network/auth_interceptor.dart
//
// 自動附加 Authorization 標頭（token 存於 flutter_secure_storage）。
// 合規：token 不經 URI / log 暴露；取覽醫健通時另由 ehealth_interceptor 處理。

import 'package:dio/dio.dart';
import 'package:rehab_med/core/config/constants.dart';
import 'package:rehab_med/core/storage/secure_storage.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._secureStorage);
  final SecureStorage _secureStorage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token =
        await _secureStorage.readSecret(AppConstants.secureStorageTokenKey);
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
