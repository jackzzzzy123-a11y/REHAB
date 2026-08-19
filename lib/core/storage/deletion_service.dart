// lib/core/storage/deletion_service.dart
//
// 刪除與保留策略服務（Q11）。
// - 軟刪：標記 PatientProfile.isActive=false，PII 仍留本地，待保留政策決定。
// - 硬刪(purge)：銷毀開關觸發或手動，連帶 snapshots/media/audit 一併銷毀。
// 合規：保留政策（保留期 / 自動銷毀）待定，此處僅留「開關 + 鉤子」。

import 'package:shared_preferences/shared_preferences.dart';

import 'local_storage_service.dart';

class DeletionService {
  const DeletionService({required this.storage, required this.prefs});
  final LocalStorageService storage;
  final SharedPreferences prefs;

  static const String _retentionKey = 'retention_enabled';

  /// 保留開關：預設開啟（先全留，符合 Q11「暫不定，先全留」）。
  Future<bool> get retentionEnabled async =>
      prefs.getBool(_retentionKey) ?? true;

  Future<void> setRetentionEnabled({required bool enabled}) =>
      prefs.setBool(_retentionKey, enabled);

  /// 軟刪：保留資料，僅標記停用（專家端列表自動過濾）。
  Future<void> softDeletePatient(String id) async {
    final patient = await storage.getPatient(id);
    if (patient == null) return;
    await storage.savePatient(patient.copyWith(isActive: false));
  }

  /// 硬刪：銷毀患者及其所有關聯資料。
  Future<void> purgePatient(String id) async {
    await storage.deletePatient(id);
    await storage.deleteSnapshotsForPatient(id);
    await storage.deleteMediaForPatient(id);
    await storage.deleteAuditForPatient(id);
  }
}
