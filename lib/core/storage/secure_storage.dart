// lib/core/storage/secure_storage.dart
//
// 加密 KV 封裝（flutter_secure_storage，底層 Keychain / Keystore）。
// 用途：僅存放 token、加解密金鑰等機密；絕不存明文病人敏感資料（PDPO 第4原則）。

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  SecureStorage(this._storage);
  final FlutterSecureStorage _storage;

  Future<void> writeSecret(String key, String value) =>
      _storage.write(key: key, value: value);
  Future<String?> readSecret(String key) => _storage.read(key: key);
  Future<void> deleteSecret(String key) => _storage.delete(key: key);
}

/// 全域加密儲存 Provider（Riverpod 作為 DI）。
/// 合規：底層為 Keychain / Keystore，僅存放 token 等機密（PDPO 第4原則）。
final secureStorageProvider = Provider<SecureStorage>(
  (ref) => SecureStorage(const FlutterSecureStorage()),
);
