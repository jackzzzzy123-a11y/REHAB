// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rehab_snapshot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SnapshotSummaryImpl _$$SnapshotSummaryImplFromJson(
        Map<String, dynamic> json) =>
    _$SnapshotSummaryImpl(
      completionRate: (json['completionRate'] as num?)?.toDouble(),
      trendDirection: json['trendDirection'] as String?,
      riskLevel: $enumDecodeNullable(_$RehabRiskEnumMap, json['riskLevel']),
      note: json['note'] as String?,
    );

Map<String, dynamic> _$$SnapshotSummaryImplToJson(
        _$SnapshotSummaryImpl instance) =>
    <String, dynamic>{
      'completionRate': instance.completionRate,
      'trendDirection': instance.trendDirection,
      'riskLevel': _$RehabRiskEnumMap[instance.riskLevel],
      'note': instance.note,
    };

const _$RehabRiskEnumMap = {
  RehabRisk.low: 'low',
  RehabRisk.medium: 'medium',
  RehabRisk.high: 'high',
};

_$RehabSnapshotImpl _$$RehabSnapshotImplFromJson(Map<String, dynamic> json) =>
    _$RehabSnapshotImpl(
      patientId: json['patientId'] as String,
      batchId: json['batchId'] as String,
      testDate: DateTime.parse(json['testDate'] as String),
      metrics: (json['metrics'] as List<dynamic>)
          .map((e) => Metric.fromJson(e as Map<String, dynamic>))
          .toList(),
      summary: json['summary'] == null
          ? null
          : SnapshotSummary.fromJson(json['summary'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$RehabSnapshotImplToJson(_$RehabSnapshotImpl instance) =>
    <String, dynamic>{
      'patientId': instance.patientId,
      'batchId': instance.batchId,
      'testDate': instance.testDate.toIso8601String(),
      'metrics': instance.metrics.map((e) => e.toJson()).toList(),
      'summary': instance.summary?.toJson(),
    };
