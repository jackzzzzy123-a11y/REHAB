// lib/features/auth/providers/auth_provider.dart
//
// 認證狀態與 Provider（Riverpod 作為 DI）。
// - AuthNotifier：登入 / 登出 / 啟動還原會話，並將 token 與非敏感識別寫入加密儲存。
// 合規：token 存於 flutter_secure_storage（Keychain/Keystore），絕不寫入日誌或 URI。

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rehab_med/core/config/constants.dart';
import 'package:rehab_med/core/errors/failures.dart';
import 'package:rehab_med/core/storage/secure_storage.dart';

import '../data/mock_auth_service.dart';
import '../domain/app_user.dart';
import '../domain/user_role.dart';

class AuthState {
  const AuthState({this.user, this.isLoading = false, this.error});
  final AppUser? user;
  final bool isLoading;
  final String? error;

  bool get isLoggedIn => user != null;

  AuthState copyWith({
    AppUser? user,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) =>
      AuthState(
        user: user ?? this.user,
        isLoading: isLoading ?? this.isLoading,
        error: clearError ? null : (error ?? this.error),
      );
}

final mockAuthServiceProvider = Provider<MockAuthService>((ref) {
  return MockAuthService();
});

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    secureStorage: ref.watch(secureStorageProvider),
    authService: ref.watch(mockAuthServiceProvider),
  );
});

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier({required this.secureStorage, required this.authService})
      : super(const AuthState());

  final SecureStorage secureStorage;
  final MockAuthService authService;

  // 應用啟動時還原會話（若已持久化 token）。
  Future<void> restoreSession() async {
    final token =
        await secureStorage.readSecret(AppConstants.secureStorageTokenKey);
    if (token == null || token.isEmpty) return;

    final id =
        await secureStorage.readSecret(AppConstants.secureStorageUserIdKey);
    final name = await secureStorage
        .readSecret(AppConstants.secureStorageUserNameKey);
    final roleStr = await secureStorage
        .readSecret(AppConstants.secureStorageUserRoleKey);
    if (id == null || name == null || roleStr == null) return;

    UserRole? role;
    for (final r in UserRole.values) {
      if (r.name == roleStr) {
        role = r;
        break;
      }
    }
    if (role == null) return;

    state = AuthState(
      user: AppUser(id: id, displayName: name, role: role),
    );
  }

  Future<void> login({
    required UserRole role,
    required String username,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final result = await authService.login(
        role: role,
        username: username,
        password: password,
      );
      await secureStorage.writeSecret(
        AppConstants.secureStorageTokenKey,
        result.token,
      );
      await secureStorage.writeSecret(
        AppConstants.secureStorageUserIdKey,
        result.user.id,
      );
      await secureStorage.writeSecret(
        AppConstants.secureStorageUserNameKey,
        result.user.displayName,
      );
      await secureStorage.writeSecret(
        AppConstants.secureStorageUserRoleKey,
        result.user.role.name,
      );
      state = AuthState(user: result.user);
    } on AuthFailure catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (_) {
      state = state.copyWith(isLoading: false, error: '登入失敗，請稍後再試');
    }
  }

  Future<void> logout() async {
    await secureStorage.deleteSecret(AppConstants.secureStorageTokenKey);
    await secureStorage.deleteSecret(AppConstants.secureStorageUserIdKey);
    await secureStorage.deleteSecret(AppConstants.secureStorageUserNameKey);
    await secureStorage
        .deleteSecret(AppConstants.secureStorageUserRoleKey);
    state = const AuthState();
  }
}
