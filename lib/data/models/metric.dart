// lib/data/models/metric.dart
//
// 康复指标模型（数据驱动核心）。外部项目分析的"已分析结果"由本模型承载，
// 仪表板据 `kind` / `category` / `series` 自动选图，不写死任何指标。
// 合規：僅存已分析輸出 + 必要 PII；絕不於本 App 重新計算指標。
// 執行 `flutter pub run build_runner build --delete-conflicting-outputs` 生成 .freezed.dart / .g.dart。

import 'package:freezed_annotation/freezed_annotation.dart';

import 'trend_point.dart';

part 'metric.freezed.dart';
part 'metric.g.dart';

/// 指标型别，决定仪表板选哪种图型。
/// 对应外部分析结果中的 `kind` 字段（序列化用 name 字符串）。
enum MetricKind {
  /// 百分比 → 仪表盘（完成%）
  percentage,

  /// 数值（通常带时序 series）→ 折线（趋势）
  numeric,

  /// 评分（0–100 等）→ 仪表盘 / 进度
  score,

  /// 枚举/分类值 → 文本/徽章
  enumeration,
}

/// 指标健康状态，用于风险标色（红/黄/绿）。
enum MetricStatus {
  normal,
  warning,
  abnormal,
}

/// 参考区间，用于异常判定与标红（如关节活动度上下限）。
@freezed
class ReferenceRange with _$ReferenceRange {
  const factory ReferenceRange({
    required double low,
    required double high,
    double? normalLow,
    double? normalHigh,
  }) = _ReferenceRange;

  factory ReferenceRange.fromJson(Map<String, dynamic> json) =>
      _$ReferenceRangeFromJson(json);
}

/// 单条康复指标（数据驱动）。汇入里有什么指标，仪表板就画什么图。
@freezed
@JsonSerializable(explicitToJson: true)
class Metric with _$Metric {
  const factory Metric({
    required String key,
    required String label,
    required MetricKind kind,
    required double value,
    required String unit,
    ReferenceRange? referenceRange,
    MetricStatus? status,

    /// 雷达图分组键（如 mobility / balance），多指标同屏聚合用。
    String? category,

    /// 该指标的纵向时序点（同病人不同测试批次），用于趋势对比。
    @Default(<TrendPoint>[]) List<TrendPoint> series,

    /// 未知字段原样保留，避免汇入时丢信息（schema 无关缓冲）。
    Map<String, dynamic>? ext,
  }) = _Metric;

  factory Metric.fromJson(Map<String, dynamic> json) => _$MetricFromJson(json);
}
