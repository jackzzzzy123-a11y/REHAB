// lib/data/datasources/local/local_cache.dart
//
// 本地快取資料源（Hive）。僅存放脫敏後資料；敏感欄位先加密。

import '../../../core/storage/hive_storage.dart';

class LocalCache {
  LocalCache(this._storage);
  final HiveStorage _storage;

  Future<void> put(String key, dynamic value) => _storage.put(key, value);
  dynamic get(String key) => _storage.get(key);

  // TODO: 實作快取策略（優先回傳離線資料，背景同步遠端）
}
