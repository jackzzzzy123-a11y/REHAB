// lib/core/storage/local_storage_service.dart
//
// 本地加密儲存服務（Hive + AES-GCM at rest）。
// 職責：以加密盒持久化患者 PII、康復快照、輔助媒體、匯入批次、審計日誌。
// 合規：AES 金鑰存於 Keychain/Keystore（flutter_secure_storage）；本機靜態加密（PDPO 第4原則）。
// 設計：盒以 JSON Map 儲存（模型 toJson/fromJson），免去 Hive TypeAdapter 生成，
//       且契合「資料驅動 / schema 無關」哲學。

import 'dart:convert';

import 'package:hive/hive.dart';

import '../../data/models/audit_entry.dart';
import '../../data/models/import_batch.dart';
import '../../data/models/media_asset.dart';
import '../../data/models/patient_profile.dart';
import '../../data/models/rehab_snapshot.dart';
import '../config/constants.dart';
import '../security/encryption.dart';

class LocalStorageService {
  LocalStorageService(this._encryption);
  final Encryption _encryption;

  bool _opened = false;
  late Box<Map<dynamic, dynamic>> _patientsBox;
  late Box<Map<dynamic, dynamic>> _snapshotsBox;
  late Box<Map<dynamic, dynamic>> _mediaBox;
  late Box<Map<dynamic, dynamic>> _metaBox;
  late Box<Map<dynamic, dynamic>> _auditBox;

  Future<void> _ensureOpen() async {
    if (_opened) return;
    final cipher = HiveAesCipher(_encryption.keyBytes);
    _patientsBox = await Hive.openBox<Map<dynamic, dynamic>>(
      AppConstants.hivePatientsBox,
      encryptionCipher: cipher,
    );
    _snapshotsBox = await Hive.openBox<Map<dynamic, dynamic>>(
      AppConstants.hiveSnapshotsBox,
      encryptionCipher: cipher,
    );
    _mediaBox = await Hive.openBox<Map<dynamic, dynamic>>(
      AppConstants.hiveMediaBox,
      encryptionCipher: cipher,
    );
    _metaBox = await Hive.openBox<Map<dynamic, dynamic>>(
      AppConstants.hiveMetaBox,
      encryptionCipher: cipher,
    );
    _auditBox = await Hive.openBox<Map<dynamic, dynamic>>(
      AppConstants.hiveAuditBox,
      encryptionCipher: cipher,
    );
    _opened = true;
  }

  // Hive 從磁碟重開後，map 實際型別為 Map<dynamic, dynamic>（非 Map<String, dynamic>），
  // 且嵌套物件亦然。直接傳給 fromJson 會在型別強轉時崩潰（「離線重開」場景）。
  // 用 JSON 往返一次性把任意深度的嵌套規範為 Map<String, dynamic>/List（資料源自 toJson，必為 JSON 安全）。
  static Map<String, dynamic> _typedMap(Map<dynamic, dynamic> raw) =>
      jsonDecode(jsonEncode(raw)) as Map<String, dynamic>;

  // ---- Patients (含 PII) ----
  Future<void> savePatient(PatientProfile patient) async {
    await _ensureOpen();
    await _patientsBox.put(patient.patientId, patient.toJson());
  }

  Future<PatientProfile?> getPatient(String id) async {
    await _ensureOpen();
    final map = _patientsBox.get(id);
    if (map == null) return null;
    return PatientProfile.fromJson(_typedMap(map));
  }

  Future<List<PatientProfile>> getAllPatients() async {
    await _ensureOpen();
    return _patientsBox.values
        .map((m) => PatientProfile.fromJson(_typedMap(m)))
        .toList();
  }

  Future<List<PatientProfile>> getActivePatients() async {
    final all = await getAllPatients();
    return all.where((patient) => patient.isActive).toList();
  }

  Future<void> deletePatient(String id) async {
    await _ensureOpen();
    await _patientsBox.delete(id);
  }

  // ---- Snapshots（已分析輸出包）----
  Future<void> saveSnapshot(RehabSnapshot snapshot) async {
    await _ensureOpen();
    await _snapshotsBox.put(snapshot.batchId, snapshot.toJson());
  }

  Future<List<RehabSnapshot>> getSnapshotsForPatient(String patientId) async {
    await _ensureOpen();
    final result = <RehabSnapshot>[];
    for (final map in _snapshotsBox.values) {
      final snap = RehabSnapshot.fromJson(_typedMap(map));
      if (snap.patientId == patientId) result.add(snap);
    }
    result.sort((a, b) => a.testDate.compareTo(b.testDate));
    return result;
  }

  Future<void> deleteSnapshotsForPatient(String patientId) async {
    await _ensureOpen();
    final keys = <dynamic>[];
    for (final key in _snapshotsBox.keys) {
      final map = _snapshotsBox.get(key);
      if (map != null &&
          RehabSnapshot.fromJson(_typedMap(map)).patientId == patientId) {
        keys.add(key);
      }
    }
    await _snapshotsBox.deleteAll(keys);
  }

  // ---- Media（模糊後輔助影像）----
  Future<void> saveMedia(MediaAsset asset) async {
    await _ensureOpen();
    await _mediaBox.put(asset.assetId, asset.toJson());
  }

  Future<List<MediaAsset>> getMediaForPatient(String patientId) async {
    await _ensureOpen();
    final result = <MediaAsset>[];
    for (final map in _mediaBox.values) {
      final asset = MediaAsset.fromJson(_typedMap(map));
      if (asset.patientId == patientId) result.add(asset);
    }
    return result;
  }

  Future<void> deleteMediaForPatient(String patientId) async {
    await _ensureOpen();
    final keys = <dynamic>[];
    for (final key in _mediaBox.keys) {
      final map = _mediaBox.get(key);
      final matches = map != null &&
          MediaAsset.fromJson(_typedMap(map)).patientId == patientId;
      if (matches) {
        keys.add(key);
      }
    }
    await _mediaBox.deleteAll(keys);
  }

  // ---- Import batches（meta / 溯源）----
  Future<void> saveBatch(ImportBatch batch) async {
    await _ensureOpen();
    await _metaBox.put(batch.batchId, batch.toJson());
  }

  Future<List<ImportBatch>> getBatches() async {
    await _ensureOpen();
    return _metaBox.values
        .map((m) => ImportBatch.fromJson(_typedMap(m)))
        .toList();
  }

  // ---- Audit（存取審計）----
  Future<void> appendAudit(AuditEntry entry) async {
    await _ensureOpen();
    await _auditBox.add(entry.toJson());
  }

  Future<List<AuditEntry>> getAuditForPatient(String patientId) async {
    await _ensureOpen();
    final result = <AuditEntry>[];
    for (final map in _auditBox.values) {
      final entry = AuditEntry.fromJson(_typedMap(map));
      if (entry.patientId == patientId) result.add(entry);
    }
    result.sort((a, b) => b.at.compareTo(a.at));
    return result;
  }

  Future<List<AuditEntry>> getAllAudit() async {
    await _ensureOpen();
    return _auditBox.values
        .map((m) => AuditEntry.fromJson(_typedMap(m)))
        .toList();
  }

  Future<void> deleteAuditForPatient(String patientId) async {
    await _ensureOpen();
    final keys = <dynamic>[];
    for (final key in _auditBox.keys) {
      final map = _auditBox.get(key);
      final matches = map != null &&
          AuditEntry.fromJson(_typedMap(map)).patientId == patientId;
      if (matches) {
        keys.add(key);
      }
    }
    await _auditBox.deleteAll(keys);
  }
}
