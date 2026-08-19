// lib/features/patient_dashboard/analytics/history_tab.dart
//
// 下鑽：歷次測試（P1-4）。列出該患者所有批次（縱向），並預設對比最近兩批次。
// 合規：不跨病人對比；僅展示已分析輸出值。

import 'package:flutter/material.dart';
import 'package:rehab_med/l10n/generated/app_localizations.dart';

import '../../../data/models/rehab_snapshot.dart';

String _fmt(DateTime d) => '${d.year}-${d.month}-${d.day}';

class HistoryTab extends StatelessWidget {
  const HistoryTab({required this.snapshots, super.key});
  final List<RehabSnapshot> snapshots;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final latest = snapshots.last;
    final a = snapshots.length > 1
        ? snapshots[snapshots.length - 2]
        : snapshots.first;
    final b = latest;

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Text(l10n.historyTitle,
            style: Theme.of(context).textTheme.titleSmall,),
        const SizedBox(height: 8),
        for (final s in snapshots)
          ListTile(
            leading: const Icon(Icons.event),
            title: Text('${l10n.batchLabel}：${s.batchId}'),
            subtitle: Text(
              '${l10n.testDateLabel}：${_fmt(s.testDate)} · '
              '${l10n.metricsCount} ${s.metrics.length}',
            ),
            trailing: s == latest ? Chip(label: Text(l10n.latestBadge)) : null,
          ),
        const Divider(),
        Text(l10n.compareTitle,
            style: Theme.of(context).textTheme.titleSmall,),
        const SizedBox(height: 8),
        ..._compareRows(a, b, l10n),
      ],
    );
  }

  List<Widget> _compareRows(
    RehabSnapshot a,
    RehabSnapshot b,
    AppLocalizations l10n,
  ) {
    final aMap = {for (final m in a.metrics) m.key: m};
    final bMap = {for (final m in b.metrics) m.key: m};
    final keys = aMap.keys.where(bMap.containsKey).toList();
    if (keys.isEmpty) return [Text(l10n.noCompareData)];

    final header = Row(
      children: [
        Expanded(flex: 2, child: Text(l10n.metricLabel)),
        Expanded(child: Text(a.batchId, textAlign: TextAlign.end)),
        Expanded(child: Text(b.batchId, textAlign: TextAlign.end)),
        Expanded(child: Text(l10n.deltaLabel, textAlign: TextAlign.end)),
      ],
    );
    final rows = <Widget>[header];
    for (final k in keys) {
      final ma = aMap[k]!;
      final mb = bMap[k]!;
      final delta = mb.value - ma.value;
      rows.add(
        Row(
          children: [
            Expanded(flex: 2, child: Text(ma.label)),
            Expanded(
              child: Text('${ma.value.toStringAsFixed(0)}${ma.unit}',
                  textAlign: TextAlign.end,),
            ),
            Expanded(
              child: Text('${mb.value.toStringAsFixed(0)}${mb.unit}',
                  textAlign: TextAlign.end,),
            ),
            Expanded(
              child: Text(
                '${delta >= 0 ? '+' : ''}${delta.toStringAsFixed(0)}',
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: delta >= 0 ? Colors.green : Colors.red,
                ),
              ),
            ),
          ],
        ),
      );
    }
    return rows;
  }
}
