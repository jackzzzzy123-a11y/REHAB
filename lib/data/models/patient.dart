// lib/data/models/patient.dart
//
// 患者模型（freezed）。範例欄位均為非敏感或脫敏後展示欄位。
// 合規：開發/測試僅用脫敏虛擬 fixtures，絕不載入真實病人資料。
//       執行 `flutter pub run build_runner build` 生成 .freezed.dart / .g.dart。

import 'package:freezed_annotation/freezed_annotation.dart';

part 'patient.freezed.dart';
part 'patient.g.dart';

@freezed
class Patient with _$Patient {
  const factory Patient({
    required String patientId, // 脫敏後之內部識別碼，非真實身份證
    required String displayName, // 展示用代稱（如「床號 + 匿稱」）
    required String rehabStage,
    String? bedNo, // 床號（用於搜尋／展示，非敏感身份資料）
  }) = _Patient;

  factory Patient.fromJson(Map<String, dynamic> json) =>
      _$PatientFromJson(json);
}
