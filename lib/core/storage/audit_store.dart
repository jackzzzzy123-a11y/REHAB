// lib/core/storage/audit_store.dart
//
// 審計儲存門面（Q18 / Q35）。底層落本地 audit 加密盒。
// 專家可看自己綁定患者之審計，不另設 Admin 角色。

import '../../data/models/audit_entry.dart';
import 'local_storage_service.dart';

class AuditStore {
  AuditStore(this.storage);
  final LocalStorageService storage;

  Future<void> append(AuditEntry entry) => storage.appendAudit(entry);
  Future<List<AuditEntry>> forPatient(String patientId) =>
      storage.getAuditForPatient(patientId);
  Future<List<AuditEntry>> all() => storage.getAllAudit();
}
