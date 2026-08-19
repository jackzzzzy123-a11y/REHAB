// lib/core/security/biometric.dart
//
// 生物辨識閘門（local_auth）。
// 用途：開啟 App / 進入敏感頁面前驗證，落實「有需要知道」存取控制 UX。

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:local_auth/local_auth.dart';

import '../utils/logger.dart';

class Biometric {
  Biometric(this._auth);
  final LocalAuthentication _auth;

  Future<bool> authenticate() {
    if (kIsWeb) {
      // Web 端 local_auth 不支援生物辨識 → 降級為無生物鎖閘門
      // （決策與備援方案見 docs/cross_platform_matrix.md §生物鎖）。
      appLogger.w('生物辨識於 Web 端不可用，已降級跳過（雙端矩陣 §生物鎖）');
      return Future.value(true);
    }
    return _auth.authenticate(
      localizedReason: '請使用生物辨識以進入應用',
      options: const AuthenticationOptions(biometricOnly: true),
    );
  }
}
