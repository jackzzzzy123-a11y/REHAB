// lib/features/auth/domain/app_user.dart
//
// 已登入使用者（脫敏識別資訊）。不含任何病人敏感資料。
// 僅持久化非敏感的識別欄位，供重新啟動時還原會話。

import 'user_role.dart';

class AppUser {
  const AppUser({
    required this.id,
    required this.displayName,
    required this.role,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        id: json['id'] as String,
        displayName: json['displayName'] as String,
        role: UserRole.values.firstWhere((r) => r.name == json['role']),
      );

  final String id;
  final String displayName;
  final UserRole role;

  AppUser copyWith({
    String? id,
    String? displayName,
    UserRole? role,
  }) =>
      AppUser(
        id: id ?? this.id,
        displayName: displayName ?? this.displayName,
        role: role ?? this.role,
      );

  Map<String, String> toJson() => {
        'id': id,
        'displayName': displayName,
        'role': role.name,
      };
}
