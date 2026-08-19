// lib/data/datasources/rehab_data_source.dart
//
// 康復資料來源抽象（P1 儲存層核心）。
// 現：FileImportDataSource（檔案匯入）；預留：ApiDataSource（phase 2 後端）。
// 職責：將外部「已分析輸出」解析為規範形 ImportContract 並寫入本地。

import '../../data/models/import_batch.dart';
import '../../data/models/patient_profile.dart';
import '../../data/models/rehab_snapshot.dart';

/// 規範形：外部檔案經適配器後，必須符合此結構方可入庫。
class ImportContract {
  const ImportContract({
    required this.patient,
    required this.snapshots,
  });
  final PatientProfile patient;
  final List<RehabSnapshot> snapshots;
}

/// 匯入校驗失敗時拋出。
class ImportValidationException implements Exception {
  const ImportValidationException(this.message);
  final String message;
  @override
  String toString() => 'ImportValidationException: $message';
}

// 故意保留抽象類別（非函式），以便 phase 2 以 ApiDataSource 替換實作。
// ignore: one_member_abstracts
abstract class RehabDataSource {
  /// 解析外部檔案內容並寫入本地儲存，回傳規範形 ImportContract。
  Future<ImportContract> importFileContent(String content, ImportFormat format);
}
