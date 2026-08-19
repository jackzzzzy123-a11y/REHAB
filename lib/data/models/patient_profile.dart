// lib/data/models/patient_profile.dart
//
// 患者档案（含 PII）。静态加密储存於 hive 加密盒。
// 合規：displayName 为展示用代稱；dateOfBirth/身高體重為必要臨床 PII，
//       須經 PII 級加密，且同意 UX 於患者上傳時補齊（P2）。
// 執行 `flutter pub run build_runner build --delete-conflicting-outputs` 生成 .freezed.dart / .g.dart。

import 'package:freezed_annotation/freezed_annotation.dart';

part 'patient_profile.freezed.dart';
part 'patient_profile.g.dart';

/// 患者完整档案（PII 级）。与 P0-1 的轻量 `Patient`（列表项）区分：
/// 此处为绑定专家可见的全部资料。
@freezed
class PatientProfile with _$PatientProfile {
  const factory PatientProfile({
    required String patientId, // 匿名内部识别码（非真实身份证）
    required String displayName, // 展示用代稱（Q7 含姓名）
    required DateTime dateOfBirth, // 出生年月
    required double heightCm,
    required double weightKg,
    required String rehabStage,
    required String expertId, // 绑定专家（同一时间仅 1 位）
    required bool isActive,
  }) = _PatientProfile;

  factory PatientProfile.fromJson(Map<String, dynamic> json) =>
      _$PatientProfileFromJson(json);
}
