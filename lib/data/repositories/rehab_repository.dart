// lib/data/repositories/rehab_repository.dart
//
// 康復資料倉儲（P1-2 儲存層門面）。組合：本地加密儲存 + 資料源 + 刪除服務 + 審計。
// 特徵層（專家儀表板、匯入精靈、審計頁）透過此倉儲存取資料，不直接碰儲存細節。

import '../../core/storage/audit_store.dart';
import '../../core/storage/deletion_service.dart';
import '../../core/storage/local_storage_service.dart';
import '../../core/storage/media_file_store.dart';
import '../../data/models/audit_entry.dart';
import '../../data/models/import_batch.dart';
import '../../data/models/media_asset.dart';
import '../../data/models/patient_profile.dart';
import '../../data/models/rehab_snapshot.dart';
import '../datasources/rehab_data_source.dart';

class RehabRepository {
  RehabRepository({
    required this.storage,
    required this.dataSource,
    required this.deletion,
    required this.auditStore,
    required this.currentExpertId,
  });
  final LocalStorageService storage;
  final RehabDataSource dataSource;
  final DeletionService deletion;
  final AuditStore auditStore;
  final String currentExpertId;

  // ---- 讀取（專家端）----
  Future<List<PatientProfile>> getActivePatients() =>
      storage.getActivePatients();
  Future<PatientProfile?> getPatient(String id) => storage.getPatient(id);
  Future<List<RehabSnapshot>> getSnapshots(String patientId) =>
      storage.getSnapshotsForPatient(patientId);
  Future<List<MediaAsset>> getMedia(String patientId) =>
      storage.getMediaForPatient(patientId);
  Future<List<ImportBatch>> getBatches() => storage.getBatches();
  Future<List<AuditEntry>> getAudit(String patientId) =>
      auditStore.forPatient(patientId);

  // ---- 匯入（解析 + 入庫 + 審計）----
  Future<ImportContract> import(String content, ImportFormat format) async {
    final contract = await dataSource.importFileContent(content, format);
    await auditStore.append(
      AuditEntry(
        actorId: currentExpertId,
        patientId: contract.patient.patientId,
        action: AuditAction.import,
        at: DateTime.now(),
      ),
    );
    return contract;
  }

  // ---- 刪除 / 保留 ----
  Future<void> softDeletePatient(String id) => deletion.softDeletePatient(id);
  Future<void> purgePatient(String id) => deletion.purgePatient(id);

  // ---- 媒體（患者端上傳，P2-d：存前已模糊 + 加密）----
  Future<void> saveMedia(MediaAsset asset) => storage.saveMedia(asset);

  /// 持久化媒體檔案（剪輯後影片）到媒體目錄，回傳 storagePath。
  ///
  /// Web 端不支援（無檔案系統），回傳 null（上層以下載標記記錄）。
  Future<String?> persistMediaFile({
    required String patientId,
    required String fileName,
    required String sourcePath,
  }) {
    return createMediaFileStore().persist(
      patientId: patientId,
      fileName: fileName,
      sourcePath: sourcePath,
    );
  }
}
