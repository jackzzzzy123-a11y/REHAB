// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuditEntryImpl _$$AuditEntryImplFromJson(Map<String, dynamic> json) =>
    _$AuditEntryImpl(
      actorId: json['actorId'] as String,
      patientId: json['patientId'] as String,
      action: $enumDecode(_$AuditActionEnumMap, json['action']),
      at: DateTime.parse(json['at'] as String),
    );

Map<String, dynamic> _$$AuditEntryImplToJson(_$AuditEntryImpl instance) =>
    <String, dynamic>{
      'actorId': instance.actorId,
      'patientId': instance.patientId,
      'action': _$AuditActionEnumMap[instance.action]!,
      'at': instance.at.toIso8601String(),
    };

const _$AuditActionEnumMap = {
  AuditAction.view: 'view',
  AuditAction.import: 'import',
  AuditAction.delete: 'delete',
  AuditAction.export: 'export',
  AuditAction.login: 'login',
};
