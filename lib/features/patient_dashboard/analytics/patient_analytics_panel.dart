// lib/features/patient_dashboard/analytics/patient_analytics_panel.dart
//
// 專家端分析面板（P1-4 右側）。組合：
//   概覽卡（summary 感知）→ 縱向趨勢（可選指標的折線）→ 下鑽 Tab
//   （運動分布[柱圖/ 雷達] / 歷次測試[列表+對比] / 輔助媒體[樁]）。
// 資料驅動：有什麼指標就畫什麼圖，不寫死。

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rehab_med/l10n/generated/app_localizations.dart';

import '../../../data/models/media_asset.dart';
import '../../../data/models/metric.dart';
import '../../../data/models/rehab_snapshot.dart';
import '../providers/dashboard_providers.dart';
import 'charts.dart';
import 'history_tab.dart';
import 'media_tab.dart';
import 'overview_cards.dart';

class PatientAnalyticsPanel extends ConsumerStatefulWidget {
  const PatientAnalyticsPanel({
    required this.patientId,
    required this.displayName,
    this.stage,
    super.key,
  });
  final String patientId;
  final String displayName;
  final String? stage;

  @override
  ConsumerState<PatientAnalyticsPanel> createState() =>
      _PatientAnalyticsPanelState();
}

class _PatientAnalyticsPanelState
    extends ConsumerState<PatientAnalyticsPanel> {
  String? _selectedTrendKey;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final snapAsync = ref.watch<AsyncValue<List<RehabSnapshot>>>(
      snapshotsProvider(widget.patientId),
    );
    final mediaAsync = ref.watch<AsyncValue<List<MediaAsset>>>(
      mediaProvider(widget.patientId),
    );

    return snapAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (Object e, _) => Center(child: Text(e.toString())),
      data: (List<RehabSnapshot> snapshots) {
        if (snapshots.isEmpty) {
          return Center(child: Text(l10n.analyticsNoData));
        }

        // 可縱向趨勢的指標：numeric / 有 series / 跨多批次出現。
        final keyLabel = <String, String>{};
        final keyKind = <String, MetricKind>{};
        final keySeries = <String, bool>{};
        final keyCount = <String, int>{};
        for (final snap in snapshots) {
          for (final m in snap.metrics) {
            keyLabel.putIfAbsent(m.key, () => m.label);
            keyKind.putIfAbsent(m.key, () => m.kind);
            keySeries[m.key] = keySeries[m.key] ?? false || m.series.isNotEmpty;
            keyCount[m.key] = (keyCount[m.key] ?? 0) + 1;
          }
        }
        final trendKeys = keyLabel.keys.where((k) {
          if (keyKind[k] == MetricKind.numeric) return true;
          if (keySeries[k] ?? false) return true;
          return (keyCount[k] ?? 0) > 1;
        }).toList();

        final trendKey = _selectedTrendKey ?? trendKeys.firstOrNull;
        Metric? trendMetric;
        if (trendKey != null) {
          for (final snap in snapshots) {
            final m = snap.metrics
                .where((Metric x) => x.key == trendKey)
                .firstOrNull;
            if (m != null) {
              trendMetric = m;
              break;
            }
          }
        }
        final points = trendKey != null
            ? trendPointsFor(trendKey, snapshots, metric: trendMetric)
            : const <(DateTime, double)>[];

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 標題
              Text(widget.displayName,
                  style: Theme.of(context).textTheme.headlineSmall,),
              if (widget.stage != null) ...[
                const SizedBox(height: 4),
                Chip(label: Text(widget.stage!)),
              ],
              const SizedBox(height: 16),

              // 概覽卡
              OverviewCards(snapshots: snapshots),
              const SizedBox(height: 24),

              // 縱向趨勢
              Text(l10n.trendTitle,
                  style: Theme.of(context).textTheme.titleMedium,),
              const SizedBox(height: 8),
              if (trendKeys.isEmpty)
                Text(l10n.analyticsNoTrend)
              else ...[
                DropdownButton<String>(
                  value: trendKey,
                  isExpanded: true,
                  hint: Text(l10n.selectMetric),
                  items: [
                    for (final k in trendKeys)
                      DropdownMenuItem(
                        value: k,
                        child: Text(keyLabel[k]!),
                      ),
                  ],
                  onChanged: (v) => setState(() => _selectedTrendKey = v),
                ),
                const SizedBox(height: 8),
                if (trendKey != null)
                  TrendLineChart(
                    points: points,
                    label: keyLabel[trendKey]!,
                    unit: trendMetric?.unit ?? '',
                    color: statusColor(trendMetric?.status),
                  ),
              ],
              const SizedBox(height: 24),

              // 下鑽 Tab
              DefaultTabController(
                length: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TabBar(
                      tabs: [
                        Tab(text: l10n.distributionTitle),
                        Tab(text: l10n.historyTitle),
                        Tab(text: l10n.mediaTitle),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 420,
                      child: TabBarView(
                        children: [
                          _DistributionTab(snapshots: snapshots),
                          HistoryTab(snapshots: snapshots),
                          mediaAsync.when(
                            data: (List<MediaAsset> m) => MediaTab(media: m),
                            loading: () => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            error: (Object e, _) =>
                                Center(child: Text(e.toString())),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DistributionTab extends StatelessWidget {
  const _DistributionTab({required this.snapshots});
  final List<RehabSnapshot> snapshots;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final latest = snapshots.last;
    final categories =
        latest.metrics.where((m) => m.kind == MetricKind.enumeration).toList();
    final bars = latest.metrics
        .where((m) =>
            m.kind == MetricKind.enumeration || m.kind == MetricKind.numeric,)
        .toList();

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        if (categories.length >= 3) ...[
          Text(l10n.radarTitle,
              style: Theme.of(context).textTheme.titleSmall,),
          const SizedBox(height: 8),
          CategoryRadar(metrics: categories),
          const SizedBox(height: 16),
        ],
        Text(l10n.distributionTitle,
            style: Theme.of(context).textTheme.titleSmall,),
        const SizedBox(height: 8),
        DistributionBar(metrics: bars),
      ],
    );
  }
}
