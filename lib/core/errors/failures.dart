// lib/core/errors/failures.dart
//
// 統一失敗模型（Failure），供 repository / UI 使用。
// 合規：錯誤訊息不得洩露病人敏感資料；對外僅顯示通用提示。

sealed class Failure implements Exception {
  const Failure(this.message);
  final String message;
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}
