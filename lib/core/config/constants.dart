// lib/core/config/constants.dart
//
// 全域常數（路由名、儲存鍵、box 名等）。集中管理避免散落。

class AppConstants {
  AppConstants._();

  static const String secureStorageTokenKey = 'auth_token';
  static const String secureStorageUserIdKey = 'auth_user_id';
  static const String secureStorageUserNameKey = 'auth_user_name';
  static const String secureStorageUserRoleKey = 'auth_user_role';
  static const String hiveCacheBox = 'rehab_cache';

  // P1-2 加密盒（AES-GCM at rest，金鑰存 secure_storage）
  static const String hivePatientsBox = 'rehab_patients';
  static const String hiveSnapshotsBox = 'rehab_snapshots';
  static const String hiveMediaBox = 'rehab_media';
  static const String hiveMetaBox = 'rehab_meta';
  static const String hiveAuditBox = 'rehab_audit';
  static const String secureStorageEncryptionKey = 'storage_enc_key';

  // 注意：儲存鍵不得包含病人敏感資料本身。
}
