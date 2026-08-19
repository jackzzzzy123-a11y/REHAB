// lib/core/storage/hive_storage.dart
//
// 本地 NoSQL 快取封裝（Hive）。
// 用途：快取「脫敏後」的患者列表 / 唯讀檢視資料，支援離線。
// 合規：敏感欄位若需快取，須先經 core/security/encryption 做 at-rest 加密。

import 'package:hive/hive.dart';

class HiveStorage {
  HiveStorage(this._box);
  final Box<dynamic> _box;

  Future<void> put(String key, dynamic value) => _box.put(key, value);
  dynamic get(String key) => _box.get(key);
}
