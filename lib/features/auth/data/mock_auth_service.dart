// lib/features/auth/data/mock_auth_service.dart
//
// 模擬登入服務（不接真實後端）。回傳脫敏虛擬憑證，供 P0-1 流程演示。
// 合規：絕不使用真實醫生／患者資料；此為開發用假資料。

import 'package:rehab_med/core/errors/failures.dart';

import '../domain/app_user.dart';
import '../domain/user_role.dart';

class AuthResult {
  const AuthResult({required this.token, required this.user});
  final String token;
  final AppUser user;
}

class MockAuthService {
  Future<AuthResult> login({
    required UserRole role,
    required String username,
    required String password,
  }) async {
    // 模擬網路延遲
    await Future<void>.delayed(const Duration(milliseconds: 600));

    final name = username.trim();
    if (name.isEmpty || password.isEmpty) {
      throw const AuthFailure('請填寫帳號與密碼');
    }
    if (password.length < 6) {
      throw const AuthFailure('密碼長度不足（至少 6 位）');
    }

    final user = AppUser(
      id: role == UserRole.doctor ? 'DOC-0001' : 'PAT-0001',
      displayName: role == UserRole.doctor ? '陳醫生' : '患者甲（家屬）',
      role: role,
    );

    // 非真實 JWT；僅作持久化與攔截器示範。
    final token = 'mock.${role.name}.${DateTime.now().millisecondsSinceEpoch}';
    return AuthResult(token: token, user: user);
  }
}
