// lib/data/models/trend_point.dart
//
// 同病人不同时间的测试点（Q9 核心：纵向对比）。
// 執行 `flutter pub run build_runner build --delete-conflicting-outputs` 生成 .freezed.dart / .g.dart。

import 'package:freezed_annotation/freezed_annotation.dart';

part 'trend_point.freezed.dart';
part 'trend_point.g.dart';

@freezed
class TrendPoint with _$TrendPoint {
  const factory TrendPoint({
    required DateTime at, // 测试/评估时间
    required double value,
    required String metricKey, // 关联 Metric.key
  }) = _TrendPoint;

  factory TrendPoint.fromJson(Map<String, dynamic> json) =>
      _$TrendPointFromJson(json);
}
