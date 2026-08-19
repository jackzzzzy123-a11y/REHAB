// lib/data/models/audit_entry.dart
//
// 存取审计条目（Q18 / Q35）。记谁、何时、对哪个病人、做了什么。
// 本地存於 audit 盒；专家可看自己绑定患者之审计，不设 Admin 第三角色。
// 執行 `flutter pub run build_runner build --delete-conflicting-outputs` 生成 .freezed.dart / .g.dart。

import 'package:freezed_annotation/freezed_annotation.dart';

part 'audit_entry.freezed.dart';
part 'audit_entry.g.dart';

enum AuditAction { view, import, delete, export, login }

@freezed
class AuditEntry with _$AuditEntry {
  const factory AuditEntry({
    required String actorId, // 谁
    required String patientId, // 看了/操作了谁
    required AuditAction action,
    required DateTime at,
  }) = _AuditEntry;

  factory AuditEntry.fromJson(Map<String, dynamic> json) =>
      _$AuditEntryFromJson(json);
}
