// lib/data/models/rehab_snapshot.dart
//
// 已分析输出包（本 App 不计算）。按 patientId 关联、按 batchId 溯源。
// 合規：僅承载外部项目分析結果；概览优先用 `summary` 块（严守不计算原则）。
// 執行 `flutter pub run build_runner build --delete-conflicting-outputs` 生成 .freezed.dart / .g.dart。

import 'package:freezed_annotation/freezed_annotation.dart';

import 'metric.dart';

part 'rehab_snapshot.freezed.dart';
part 'rehab_snapshot.g.dart';

/// 整体风险等级（若外部 summary 提供）。
enum RehabRisk { low, medium, high }

/// 概览摘要块（Q31 默认 A）。外部项目若直接给出高层字段则用之；
/// 若不存在，仪表板优雅降级为"最近一批指标列表"，本 App 不自行计算比率。
@freezed
@JsonSerializable(explicitToJson: true)
class SnapshotSummary with _$SnapshotSummary {
  const factory SnapshotSummary({
    double? completionRate, // 完成率（%）
    String? trendDirection, // 'up' | 'down' | 'flat'
    RehabRisk? riskLevel,
    String? note,
  }) = _SnapshotSummary;

  factory SnapshotSummary.fromJson(Map<String, dynamic> json) =>
      _$SnapshotSummaryFromJson(json);
}

/// 一次测试/评估的已分析结果包（纵向对比的关键单位）。
@freezed
@JsonSerializable(explicitToJson: true)
class RehabSnapshot with _$RehabSnapshot {
  const factory RehabSnapshot({
    required String patientId,
    required String batchId, // 对应 import_batch
    required DateTime testDate, // 测试/评估日期（纵向对比关键）
    required List<Metric> metrics, // 数据驱动：有什么画什么
    SnapshotSummary? summary, // 可选概览块（见 Q31）
  }) = _RehabSnapshot;

  factory RehabSnapshot.fromJson(Map<String, dynamic> json) =>
      _$RehabSnapshotFromJson(json);
}
