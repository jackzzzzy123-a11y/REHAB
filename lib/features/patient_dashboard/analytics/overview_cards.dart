// lib/features/patient_dashboard/analytics/overview_cards.dart
//
// 數據驅動概覽卡（P1-4）。
// - 有 SnapshotSummary：渲染 completionRate / riskLevel / trendDirection / note。
// - 無 summary：優雅降級為「最近一批指標列表 + 狀態標色」，本 App 不計算任何比率。
// 合規：嚴守不計算原則；所有數值皆外部預分析輸出。

import 'package:flutter/material.dart';
import 'package:rehab_med/l10n/generated/app_localizations.dart';

import '../../../data/models/rehab_snapshot.dart';
import 'charts.dart';

class OverviewCards extends StatelessWidget {
  const OverviewCards({required this.snapshots, super.key});
  final List<RehabSnapshot> snapshots;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (snapshots.isEmpty) {
      return Center(child: Text(l10n.analyticsNoData));
    }
    final latest = snapshots.last;
    return latest.summary != null
        ? _SummaryOverview(summary: latest.summary!, snapshot: latest)
        : _DegradedOverview(snapshot: latest, note: l10n.degradeNote);
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.child});
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: Theme.of(context).textTheme.labelSmall,),
              const SizedBox(height: 8),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

String _trendText(String? d, AppLocalizations l10n) {
  switch (d) {
    case 'up':
      return l10n.trendUp;
    case 'down':
      return l10n.trendDown;
    case 'flat':
      return l10n.trendFlat;
    default:
      return '—';
  }
}

IconData _trendIcon(String? d) {
  switch (d) {
    case 'up':
      return Icons.trending_up;
    case 'down':
      return Icons.trending_down;
    case 'flat':
      return Icons.trending_flat;
    default:
      return Icons.remove;
  }
}

class _SummaryOverview extends StatelessWidget {
  const _SummaryOverview({
    required this.summary,
    required this.snapshot,
  });
  final SnapshotSummary summary;
  final RehabSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            if (summary.completionRate != null)
              _StatCard(
                label: l10n.completionRateLabel,
                child: Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: summary.completionRate! / 100,
                        minHeight: 10,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('${summary.completionRate!.toInt()}%'),
                  ],
                ),
              ),
            if (summary.riskLevel != null)
              _StatCard(
                label: l10n.riskLabel,
                child: Chip(
                  avatar: Icon(Icons.circle,
                      color: riskColor(summary.riskLevel), size: 10,),
                  label: Text(riskLabel(summary.riskLevel)),
                  backgroundColor:
                      riskColor(summary.riskLevel).withValues(alpha: 0.15),
                ),
              ),
            if (summary.completionRate != null)
              _StatCard(
                label: l10n.trendTitle,
                child: Chip(
                  avatar: Icon(_trendIcon(summary.trendDirection),
                      size: 16,),
                  label: Text(_trendText(summary.trendDirection, l10n)),
                ),
              ),
          ],
        ),
        if (summary.note != null) ...[
          const SizedBox(height: 12),
          Text('${l10n.noteLabel}：${summary.note}'),
        ],
      ],
    );
  }
}

class _DegradedOverview extends StatelessWidget {
  const _DegradedOverview({
    required this.snapshot,
    required this.note,
  });
  final RehabSnapshot snapshot;
  final String note;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(note, style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(height: 8),
        ...snapshot.metrics.map(
          (m) => ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.circle, color: statusColor(m.status), size: 12),
            title: Text(m.label),
            trailing: Text('${m.value.toStringAsFixed(0)} ${m.unit}'),
          ),
        ),
        const SizedBox(height: 8),
        Text(l10n.analyticsNoSummaryHint,
            style: Theme.of(context).textTheme.labelSmall,),
      ],
    );
  }
}
