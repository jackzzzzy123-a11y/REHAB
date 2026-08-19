// lib/core/security/encryption.dart
//
// 靜態加密（AES-GCM），用於本地快取的敏感欄位。
// 金鑰由 flutter_secure_storage 保管（見 core/storage/secure_storage.dart）。
// 合規：PDPO 第4原則 — 採取切實可行的步驟保障個人資料。

import 'package:encrypt/encrypt.dart';

class Encryption {
  Encryption(this._key);
  final Key _key;

  /// AES 金鑰位元組（供 HiveAesCipher 做 at-rest 加密）。
  List<int> get keyBytes => _key.bytes;

  // 傳回 'ivBase64:cipherBase64'，IV 每次隨機生成。
  String encryptText(String plain) {
    final encrypter = Encrypter(AES(_key, mode: AESMode.gcm));
    final iv = IV.fromSecureRandom(12);
    final encrypted = encrypter.encrypt(plain, iv: iv);
    return '${iv.base64}:${encrypted.base64}';
  }

  String decryptText(String cipher) {
    final parts = cipher.split(':');
    final iv = IV.fromBase64(parts[0]);
    final encrypter = Encrypter(AES(_key, mode: AESMode.gcm));
    return encrypter.decrypt(Encrypted.fromBase64(parts[1]), iv: iv);
  }
}
