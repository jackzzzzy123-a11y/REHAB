// lib/features/patient_dashboard/analytics/charts.dart
//
// 數據驅動圖表元件（fl_chart）。按 Metric.kind 自動選圖的「原子」元件 +
// 狀態/風險配色助手。組合邏輯（何時用雷達 / 何時用單指標圖）在面板層決定。
// 合規：僅視覺化外部已分析輸出，不在此計算任何衍生指標。

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../data/models/metric.dart';
import '../../../data/models/rehab_snapshot.dart';

// ---- 配色助手 ----

Color statusColor(MetricStatus? s) {
  switch (s) {
    case MetricStatus.normal:
      return Colors.green;
    case MetricStatus.warning:
      return Colors.orange;
    case MetricStatus.abnormal:
      return Colors.red;
    case null:
      return Colors.blueGrey;
  }
}

Color riskColor(RehabRisk? r) {
  switch (r) {
    case RehabRisk.low:
      return Colors.green;
    case RehabRisk.medium:
      return Colors.orange;
    case RehabRisk.high:
      return Colors.red;
    case null:
      return Colors.grey;
  }
}

String riskLabel(RehabRisk? r) {
  switch (r) {
    case RehabRisk.low:
      return '低';
    case RehabRisk.medium:
      return '中';
    case RehabRisk.high:
      return '高';
    case null:
      return '—';
  }
}

/// 取指標的「縱向趨勢點」：優先用指標自帶 series（同指標多時間點），
/// 否則跨該患者多批次快照聚合（同 key 的 value 隨 testDate）。
List<(DateTime, double)> trendPointsFor(
  String key,
  List<RehabSnapshot> snapshots, {
  Metric? metric,
}) {
  if (metric != null && metric.series.isNotEmpty) {
    final sorted = [...metric.series]
      ..sort((a, b) => a.at.compareTo(b.at));
    return sorted.map((t) => (t.at, t.value)).toList();
  }
  final points = <(DateTime, double)>[];
  for (final snap in snapshots) {
    final m = snap.metrics.where((x) => x.key == key).firstOrNull;
    if (m != null) points.add((snap.testDate, m.value));
  }
  points.sort((a, b) => a.$1.compareTo(b.$1));
  return points;
}

// ---- 儀表盤（percentage / score）----

class MetricGauge extends StatelessWidget {
  const MetricGauge({required this.metric, super.key});
  final Metric metric;

  @override
  Widget build(BuildContext context) {
    final fill = metric.value.clamp(0, 100) / 100;
    final color = statusColor(metric.status);
    return SizedBox(
      height: 150,
      width: 150,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              startDegreeOffset: -90,
              sectionsSpace: 2,
              centerSpaceRadius: 42,
              sections: [
                PieChartSectionData(
                  value: fill * 100,
                  color: color,
                  radius: 14,
                  title: '',
                ),
                PieChartSectionData(
                  value: (1 - fill) * 100,
                  color: Colors.grey.shade200,
                  radius: 14,
                  title: '',
                ),
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${metric.value.toStringAsFixed(0)}${metric.unit}',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 2),
              Text(
                metric.label,
                style: Theme.of(context).textTheme.labelSmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---- 趨勢折線（numeric + series / 跨批次縱向）----

class TrendLineChart extends StatelessWidget {
  const TrendLineChart({
    required this.points,
    required this.label,
    required this.unit,
    required this.color,
    super.key,
  });
  final List<(DateTime, double)> points;
  final String label;
  final String unit;
  final Color color;

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) {
      return const Center(child: Text('暫無趨勢資料'));
    }
    final spots = [
      for (var i = 0; i < points.length; i++)
        FlSpot(i.toDouble(), points[i].$2),
    ];
    return AspectRatio(
      aspectRatio: 16 / 6,
      child: LineChart(
        LineChartData(
            gridData: const FlGridData(
              drawVerticalLine: false,
            ),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (v, meta) {
                  final i = v.toInt();
                  if (i < 0 || i >= points.length) return const Text('');
                  final d = points[i].$1;
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '${d.month}/${d.day}',
                      style: const TextStyle(fontSize: 10),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 36,
                getTitlesWidget: (v, _) => Text(
                  v.toInt().toString(),
                  style: const TextStyle(fontSize: 10),
                ),
              ),
            ),
            rightTitles: const AxisTitles(),
            topTitles: const AxisTitles(),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: color,
              barWidth: 3,
              belowBarData: BarAreaData(
                show: true,
                color: color.withValues(alpha: 0.15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---- 分布柱圖（category / numeric）----

class DistributionBar extends StatelessWidget {
  const DistributionBar({required this.metrics, super.key});
  final List<Metric> metrics;

  @override
  Widget build(BuildContext context) {
    if (metrics.isEmpty) {
      return const Center(child: Text('暫無分布資料'));
    }
    final groups = <BarChartGroupData>[];
    for (var i = 0; i < metrics.length; i++) {
      final m = metrics[i];
      groups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: m.value,
              color: statusColor(m.status),
              width: 18,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      );
    }
    return AspectRatio(
      aspectRatio: 16 / 7,
      child: BarChart(
        BarChartData(
          barGroups: groups,
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (v, meta) {
                  final i = v.toInt();
                  if (i < 0 || i >= metrics.length) {
                    return const Text('');
                  }
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      metrics[i].label,
                      style: const TextStyle(fontSize: 10),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 36,
                getTitlesWidget: (v, _) => Text(
                  v.toInt().toString(),
                  style: const TextStyle(fontSize: 10),
                ),
              ),
            ),
            rightTitles: const AxisTitles(),
            topTitles: const AxisTitles(),
          ),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }
}

// ---- 雷達圖（多 category 指標同屏聚合）----

class CategoryRadar extends StatelessWidget {
  const CategoryRadar({required this.metrics, super.key});
  final List<Metric> metrics;

  @override
  Widget build(BuildContext context) {
    if (metrics.isEmpty) {
      return const Center(child: Text('暫無分類指標'));
    }
    final dataSet = RadarDataSet(
      dataEntries: [
        for (final m in metrics) RadarEntry(value: m.value),
      ],
      fillColor: Colors.teal.withValues(alpha: 0.2),
      borderColor: Colors.teal,
    );
    return AspectRatio(
      aspectRatio: 1,
      child: RadarChart(
        RadarChartData(
          dataSets: [dataSet],
          radarBackgroundColor: Colors.transparent,
          radarBorderData: BorderSide(color: Colors.grey.shade300),
          titleTextStyle: const TextStyle(fontSize: 10),
          tickCount: 4,
          titlePositionPercentageOffset: 0.1,
          getTitle: (i, _) {
            if (i < 0 || i >= metrics.length) {
              return const RadarChartTitle(text: '');
            }
            return RadarChartTitle(text: metrics[i].label);
          },
        ),
      ),
    );
  }
}
