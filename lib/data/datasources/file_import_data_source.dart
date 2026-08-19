// lib/data/datasources/file_import_data_source.dart
//
// 檔案匯入資料源（P1 現行實作）。彈性解析 + 適配器：
// JSON → 規範形（現）；CSV 適配器留樁（待外部格式契約定義，Q12/Q36）。
// 解析後寫入本地加密儲存；審計由呼叫方（RehabRepository）補齊。

import 'dart:convert';

import '../../core/storage/local_storage_service.dart';
import '../../data/models/import_batch.dart';
import '../../data/models/patient_profile.dart';
import '../../data/models/rehab_snapshot.dart';
import 'rehab_data_source.dart';

class FileImportDataSource implements RehabDataSource {
  FileImportDataSource({required this.storage});
  final LocalStorageService storage;

  @override
  Future<ImportContract> importFileContent(
    String content,
    ImportFormat format,
  ) async {
    final json = _decode(content, format);
    final contract = _parse(json);
    await _persist(contract);
    return contract;
  }

  Map<String, dynamic> _decode(String content, ImportFormat format) {
    switch (format) {
      case ImportFormat.json:
        final decoded = jsonDecode(content);
        if (decoded is! Map<String, dynamic>) {
          throw const ImportValidationException('JSON 頂層須為物件');
        }
        return decoded;
      case ImportFormat.csv:
        throw UnimplementedError('CSV 適配器待補（P1 後續，依外部格式契約）');
      case ImportFormat.unknown:
        throw const ImportValidationException('不支援的檔案格式');
    }
  }

  ImportContract _parse(Map<String, dynamic> json) {
    final patientJson = json['patient'];
    if (patientJson is! Map<String, dynamic>) {
      throw const ImportValidationException('缺少 patient 物件');
    }
    final PatientProfile patient;
    try {
      patient = PatientProfile.fromJson(patientJson);
    } catch (_) {
      throw const ImportValidationException('patient 欄位格式錯誤');
    }

    final snapshotsJson = json['snapshots'];
    if (snapshotsJson is! List) {
      throw const ImportValidationException('缺少 snapshots 陣列');
    }

    final snapshots = <RehabSnapshot>[];
    for (final raw in snapshotsJson) {
      if (raw is! Map<String, dynamic>) {
        throw const ImportValidationException('snapshots 含非物件元素');
      }
      final snap = RehabSnapshot.fromJson(raw);
      if (snap.metrics.isEmpty) {
        throw const ImportValidationException('snapshots 含空指標集');
      }
      if (snap.patientId != patient.patientId) {
        throw const ImportValidationException(
          'snapshots.patientId 與 patient 不符',
        );
      }
      snapshots.add(snap);
    }
    if (snapshots.isEmpty) {
      throw const ImportValidationException('snapshots 不可為空');
    }
    return ImportContract(patient: patient, snapshots: snapshots);
  }

  Future<void> _persist(ImportContract contract) async {
    await storage.savePatient(contract.patient);
    for (final snap in contract.snapshots) {
      await storage.saveSnapshot(snap);
    }
    final batch = ImportBatch(
      batchId: contract.snapshots.first.batchId,
      sourceFileName: 'in-app import',
      format: ImportFormat.json,
      importedAt: DateTime.now(),
      recordCount: contract.snapshots.length,
    );
    await storage.saveBatch(batch);
  }
}
