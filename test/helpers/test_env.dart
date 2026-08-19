// test/helpers/test_env.dart
//
// 共享測試環境：記憶體版 SecureStorage + 臨時 Hive 加密盒 + 完整 Repository，
// 供 widget 測試以「預解析 Provider」模式建構（避免 loading 態卡住 pumpAndSettle）。
import 'dart:io';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:rehab_med/core/security/encryption.dart';
import 'package:rehab_med/core/storage/audit_store.dart';
import 'package:rehab_med/core/storage/deletion_service.dart';
import 'package:rehab_med/core/storage/local_storage_service.dart';
import 'package:rehab_med/core/storage/secure_storage.dart';
import 'package:rehab_med/data/datasources/file_import_data_source.dart';
import 'package:rehab_med/data/providers/rehab_providers.dart';
import 'package:rehab_med/data/repositories/rehab_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 記憶體版 SecureStorage：避免測試觸發 flutter_secure_storage 平台通道。
class FakeSecureStorage extends SecureStorage {
  FakeSecureStorage() : super(const FlutterSecureStorage());
  final Map<String, String> _store = {};

  @override
  Future<void> writeSecret(String key, String value) async =>
      _store[key] = value;

  @override
  Future<String?> readSecret(String key) async => _store[key];

  @override
  Future<void> deleteSecret(String key) async => _store.remove(key);
}

/// 測試環境：容器（含 repo / secureStorage override）+ 可注入的 repo。
class TestEnv {
  TestEnv(this.container, this.repo);
  final ProviderContainer container;
  final RehabRepository repo;
}

/// 建立測試環境：臨時 Hive 目錄 + 32 位元組 AES 金鑰 + 完整儲存/倉儲鏈。
Future<TestEnv> buildTestEnv() async {
  final dir = Directory.systemTemp.createTempSync('hive_widget_test');
  Hive.init(dir.path);
  final storage = LocalStorageService(
    Encryption(encrypt.Key.fromUtf8('0123456789abcdef0123456789abcdef')),
  );
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  final deletion = DeletionService(storage: storage, prefs: prefs);
  final audit = AuditStore(storage);
  final dataSource = FileImportDataSource(storage: storage);
  final repo = RehabRepository(
    storage: storage,
    dataSource: dataSource,
    deletion: deletion,
    auditStore: audit,
    currentExpertId: 'DOC-0001',
  );
  final container = ProviderContainer(
    overrides: [
      rehabRepositoryProvider.overrideWith((ref) async => repo),
      secureStorageProvider.overrideWithValue(FakeSecureStorage()),
    ],
  );
  return TestEnv(container, repo);
}
