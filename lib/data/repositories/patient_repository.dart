// lib/data/repositories/patient_repository.dart
//
// 患者資料存取（聚合遠端 API 與本地快取）。
// 合規：僅回傳權限內（RBAC）、脫敏後之資料。

import '../models/patient.dart';

abstract class PatientRepository {
  Future<List<Patient>> getPatients();
  Future<Patient> getPatientById(String id);
}
