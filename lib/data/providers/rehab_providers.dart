// lib/data/providers/rehab_providers.dart
//
// P1-2 資料層依賴注入（Riverpod 即 DI）。
// 啟動順序：加密金鑰(secure_storage) → 加密盒(LocalStorageService) →
//           審計 / 刪除 / 資料源 / 倉儲。均以 FutureProvider 串接，
//           特徵層（P1-4 儀表板等）以 ref.watch(...).when(...) 消費。

import 'package:encrypt/encrypt.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/config/constants.dart';
import '../../core/security/encryption.dart';
import '../../core/storage/audit_store.dart';
import '../../core/storage/deletion_service.dart';
import '../../core/storage/local_storage_service.dart';
import '../../core/storage/secure_storage.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../datasources/file_import_data_source.dart';
import '../datasources/rehab_data_source.dart';
import '../repositories/rehab_repository.dart';

/// 加密金鑰：首次產生並存於 Keychain/Keystore，之後沿用。
final encryptionProvider = FutureProvider<Encryption>((ref) async {
  final secure = ref.watch(secureStorageProvider);
  const keyName = AppConstants.secureStorageEncryptionKey;
  final stored = await secure.readSecret(keyName);
  final Key key;
  if (stored == null) {
    key = Key.fromSecureRandom(32);
    await secure.writeSecret(keyName, key.base64);
  } else {
    key = Key.fromBase64(stored);
  }
  return Encryption(key);
});

final localStorageProvider = FutureProvider<LocalStorageService>((ref) async {
  final encryption = await ref.watch(encryptionProvider.future);
  return LocalStorageService(encryption);
});

final auditStoreProvider = FutureProvider<AuditStore>((ref) async {
  final storage = await ref.watch(localStorageProvider.future);
  return AuditStore(storage);
});

final deletionServiceProvider = FutureProvider<DeletionService>((ref) async {
  final storage = await ref.watch(localStorageProvider.future);
  final prefs = await SharedPreferences.getInstance();
  return DeletionService(storage: storage, prefs: prefs);
});

final rehabDataSourceProvider = FutureProvider<RehabDataSource>((ref) async {
  final storage = await ref.watch(localStorageProvider.future);
  return FileImportDataSource(storage: storage);
});

final rehabRepositoryProvider = FutureProvider<RehabRepository>((ref) async {
  final storage = await ref.watch(localStorageProvider.future);
  final dataSource = await ref.watch(rehabDataSourceProvider.future);
  final deletion = await ref.watch(deletionServiceProvider.future);
  final audit = await ref.watch(auditStoreProvider.future);
  final auth = ref.watch(authNotifierProvider);
  return RehabRepository(
    storage: storage,
    dataSource: dataSource,
    deletion: deletion,
    auditStore: audit,
    currentExpertId: auth.user?.id ?? 'unknown_expert',
  );
});
