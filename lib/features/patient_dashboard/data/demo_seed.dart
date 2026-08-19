// lib/features/patient_dashboard/data/demo_seed.dart
//
// 內置脫敏 demo 種子（Q32 默認決策）：3 患者 × 多批次，覆蓋
// percentage / score / numeric+series / category 各 kind，並含可選 summary 塊。
// 用途：專家端「一鍵載入」即可演示 匯入→列表→data-driven 看板 同一路徑，
// 無需手動準備檔案。嚴守「不計算」原則——所有數值均為外部預分析的範例輸出。
// 合規：全為虛擬資料，絕非真實病人 PII；待真實格式契約替換（標「待真實數據替換」）。

import 'dart:convert';

import '../../../data/models/import_batch.dart';
import '../../../data/models/metric.dart';
import '../../../data/models/patient_profile.dart';
import '../../../data/models/rehab_snapshot.dart';
import '../../../data/models/trend_point.dart';
import '../../../data/repositories/rehab_repository.dart';

/// 單一患者的種子載荷（patient + 其多批次 snapshots）。
class _DemoPayload {
  const _DemoPayload({required this.patient, required this.snapshots});
  final PatientProfile patient;
  final List<RehabSnapshot> snapshots;
}

// ---- 構造輔助（減少重複）----

Metric _m({
  required String key,
  required String label,
  required MetricKind kind,
  required double value,
  required String unit,
  String? category,
  ReferenceRange? referenceRange,
  MetricStatus? status,
  List<TrendPoint> series = const [],
}) =>
    Metric(
      key: key,
      label: label,
      kind: kind,
      value: value,
      unit: unit,
      category: category,
      referenceRange: referenceRange,
      status: status,
      series: series,
    );

TrendPoint _tp(DateTime at, double value, String key) =>
    TrendPoint(at: at, value: value, metricKey: key);

DateTime _d(int y, int m, int day) => DateTime.utc(y, m, day);

// ---- 種子資料 ----

List<_DemoPayload> _buildDemoPayloads() {
  // 患者 1：術後早期，進步明顯（風險低）
  final p1 = PatientProfile(
    patientId: 'P-1001',
    displayName: '床號 A-12 · 匿稱「康」',
    dateOfBirth: _d(1958, 3, 12),
    heightCm: 168,
    weightKg: 72,
    rehabStage: '術後早期',
    expertId: 'expert-01',
    isActive: true,
  );
  final p1Snaps = [
    RehabSnapshot(
      patientId: 'P-1001',
      batchId: 'B-1001-1',
      testDate: _d(2026, 7, 1),
      summary: const SnapshotSummary(
        completionRate: 68,
        trendDirection: 'up',
        riskLevel: RehabRisk.low,
        note: '首評：關節活動度偏低，建議加強被動伸展。',
      ),
      metrics: [
        _m(
          key: 'completionRate',
          label: '運動完成率',
          kind: MetricKind.percentage,
          value: 68,
          unit: '%',
          status: MetricStatus.normal,
          series: [
            _tp(_d(2026, 6, 10), 52, 'completionRate'),
            _tp(_d(2026, 6, 20), 60, 'completionRate'),
            _tp(_d(2026, 6, 28), 64, 'completionRate'),
            _tp(_d(2026, 7, 1), 68, 'completionRate'),
          ],
        ),
        _m(
          key: 'balanceScore',
          label: '平衡評分',
          kind: MetricKind.score,
          value: 62,
          unit: '分',
          status: MetricStatus.warning,
        ),
        _m(
          key: 'romKnee',
          label: '膝關節活動度',
          kind: MetricKind.numeric,
          value: 92,
          unit: '°',
          referenceRange:
              const ReferenceRange(
                low: 0,
                high: 135,
                normalLow: 110,
                normalHigh: 135,
              ),
          status: MetricStatus.warning,
          series: [
            _tp(_d(2026, 6, 10), 78, 'romKnee'),
            _tp(_d(2026, 6, 20), 84, 'romKnee'),
            _tp(_d(2026, 6, 28), 88, 'romKnee'),
            _tp(_d(2026, 7, 1), 92, 'romKnee'),
          ],
        ),
        _m(
          key: 'strength',
          label: '肌力',
          kind: MetricKind.enumeration,
          value: 55,
          unit: '分',
          category: 'mobility',
          status: MetricStatus.warning,
        ),
        _m(
          key: 'balance',
          label: '平衡',
          kind: MetricKind.enumeration,
          value: 58,
          unit: '分',
          category: 'mobility',
          status: MetricStatus.warning,
        ),
        _m(
          key: 'endurance',
          label: '耐力',
          kind: MetricKind.enumeration,
          value: 60,
          unit: '分',
          category: 'mobility',
          status: MetricStatus.normal,
        ),
        _m(
          key: 'flexibility',
          label: '柔韌',
          kind: MetricKind.enumeration,
          value: 64,
          unit: '分',
          category: 'mobility',
          status: MetricStatus.normal,
        ),
        _m(
          key: 'coordination',
          label: '協調',
          kind: MetricKind.enumeration,
          value: 57,
          unit: '分',
          category: 'mobility',
          status: MetricStatus.warning,
        ),
      ],
    ),
    RehabSnapshot(
      patientId: 'P-1001',
      batchId: 'B-1001-2',
      testDate: _d(2026, 8, 1),
      summary: const SnapshotSummary(
        completionRate: 81,
        trendDirection: 'up',
        riskLevel: RehabRisk.low,
        note: '進步明顯：活動度接近正常下限，可進入功能性訓練。',
      ),
      metrics: [
        _m(
          key: 'completionRate',
          label: '運動完成率',
          kind: MetricKind.percentage,
          value: 81,
          unit: '%',
          status: MetricStatus.normal,
          series: [
            _tp(_d(2026, 7, 8), 70, 'completionRate'),
            _tp(_d(2026, 7, 18), 74, 'completionRate'),
            _tp(_d(2026, 7, 28), 78, 'completionRate'),
            _tp(_d(2026, 8, 1), 81, 'completionRate'),
          ],
        ),
        _m(
          key: 'balanceScore',
          label: '平衡評分',
          kind: MetricKind.score,
          value: 70,
          unit: '分',
          status: MetricStatus.normal,
        ),
        _m(
          key: 'romKnee',
          label: '膝關節活動度',
          kind: MetricKind.numeric,
          value: 104,
          unit: '°',
          referenceRange:
              const ReferenceRange(
                low: 0,
                high: 135,
                normalLow: 110,
                normalHigh: 135,
              ),
          status: MetricStatus.normal,
          series: [
            _tp(_d(2026, 7, 8), 95, 'romKnee'),
            _tp(_d(2026, 7, 18), 99, 'romKnee'),
            _tp(_d(2026, 7, 28), 102, 'romKnee'),
            _tp(_d(2026, 8, 1), 104, 'romKnee'),
          ],
        ),
        _m(
          key: 'strength',
          label: '肌力',
          kind: MetricKind.enumeration,
          value: 66,
          unit: '分',
          category: 'mobility',
          status: MetricStatus.normal,
        ),
        _m(
          key: 'balance',
          label: '平衡',
          kind: MetricKind.enumeration,
          value: 67,
          unit: '分',
          category: 'mobility',
          status: MetricStatus.normal,
        ),
        _m(
          key: 'endurance',
          label: '耐力',
          kind: MetricKind.enumeration,
          value: 71,
          unit: '分',
          category: 'mobility',
          status: MetricStatus.normal,
        ),
        _m(
          key: 'flexibility',
          label: '柔韌',
          kind: MetricKind.enumeration,
          value: 73,
          unit: '分',
          category: 'mobility',
          status: MetricStatus.normal,
        ),
        _m(
          key: 'coordination',
          label: '協調',
          kind: MetricKind.enumeration,
          value: 68,
          unit: '分',
          category: 'mobility',
          status: MetricStatus.normal,
        ),
      ],
    ),
  ];

  // 患者 2：功能恢復期，風險中等，數值中等
  final p2 = PatientProfile(
    patientId: 'P-1002',
    displayName: '床號 A-15 · 匿稱「復」',
    dateOfBirth: _d(1965, 9, 3),
    heightCm: 175,
    weightKg: 80,
    rehabStage: '功能恢復期',
    expertId: 'expert-01',
    isActive: true,
  );
  final p2Snaps = [
    RehabSnapshot(
      patientId: 'P-1002',
      batchId: 'B-1002-1',
      testDate: _d(2026, 7, 5),
      summary: const SnapshotSummary(
        completionRate: 55,
        trendDirection: 'flat',
        riskLevel: RehabRisk.medium,
        note: '完成率偏低，需確認居家訓練依從性。',
      ),
      metrics: [
        _m(
          key: 'completionRate',
          label: '運動完成率',
          kind: MetricKind.percentage,
          value: 55,
          unit: '%',
          status: MetricStatus.warning,
          series: [
            _tp(_d(2026, 6, 15), 48, 'completionRate'),
            _tp(_d(2026, 6, 25), 52, 'completionRate'),
            _tp(_d(2026, 7, 5), 55, 'completionRate'),
          ],
        ),
        _m(
          key: 'balanceScore',
          label: '平衡評分',
          kind: MetricKind.score,
          value: 58,
          unit: '分',
          status: MetricStatus.warning,
        ),
        _m(
          key: 'romKnee',
          label: '膝關節活動度',
          kind: MetricKind.numeric,
          value: 88,
          unit: '°',
          referenceRange:
              const ReferenceRange(
                low: 0,
                high: 135,
                normalLow: 110,
                normalHigh: 135,
              ),
          status: MetricStatus.warning,
          series: [
            _tp(_d(2026, 6, 15), 80, 'romKnee'),
            _tp(_d(2026, 6, 25), 84, 'romKnee'),
            _tp(_d(2026, 7, 5), 88, 'romKnee'),
          ],
        ),
        _m(
          key: 'strength',
          label: '肌力',
          kind: MetricKind.enumeration,
          value: 50,
          unit: '分',
          category: 'mobility',
          status: MetricStatus.warning,
        ),
        _m(
          key: 'balance',
          label: '平衡',
          kind: MetricKind.enumeration,
          value: 54,
          unit: '分',
          category: 'mobility',
          status: MetricStatus.warning,
        ),
        _m(
          key: 'endurance',
          label: '耐力',
          kind: MetricKind.enumeration,
          value: 52,
          unit: '分',
          category: 'mobility',
          status: MetricStatus.warning,
        ),
        _m(
          key: 'flexibility',
          label: '柔韌',
          kind: MetricKind.enumeration,
          value: 56,
          unit: '分',
          category: 'mobility',
          status: MetricStatus.warning,
        ),
        _m(
          key: 'coordination',
          label: '協調',
          kind: MetricKind.enumeration,
          value: 51,
          unit: '分',
          category: 'mobility',
          status: MetricStatus.warning,
        ),
      ],
    ),
    RehabSnapshot(
      patientId: 'P-1002',
      batchId: 'B-1002-2',
      testDate: _d(2026, 8, 5),
      summary: const SnapshotSummary(
        completionRate: 63,
        trendDirection: 'up',
        riskLevel: RehabRisk.medium,
        note: '小幅進步，依從性略改善，持續觀察。',
      ),
      metrics: [
        _m(
          key: 'completionRate',
          label: '運動完成率',
          kind: MetricKind.percentage,
          value: 63,
          unit: '%',
          status: MetricStatus.warning,
          series: [
            _tp(_d(2026, 7, 15), 58, 'completionRate'),
            _tp(_d(2026, 7, 25), 60, 'completionRate'),
            _tp(_d(2026, 8, 5), 63, 'completionRate'),
          ],
        ),
        _m(
          key: 'balanceScore',
          label: '平衡評分',
          kind: MetricKind.score,
          value: 61,
          unit: '分',
          status: MetricStatus.warning,
        ),
        _m(
          key: 'romKnee',
          label: '膝關節活動度',
          kind: MetricKind.numeric,
          value: 94,
          unit: '°',
          referenceRange:
              const ReferenceRange(
                low: 0,
                high: 135,
                normalLow: 110,
                normalHigh: 135,
              ),
          status: MetricStatus.warning,
          series: [
            _tp(_d(2026, 7, 15), 89, 'romKnee'),
            _tp(_d(2026, 7, 25), 92, 'romKnee'),
            _tp(_d(2026, 8, 5), 94, 'romKnee'),
          ],
        ),
        _m(
          key: 'strength',
          label: '肌力',
          kind: MetricKind.enumeration,
          value: 57,
          unit: '分',
          category: 'mobility',
          status: MetricStatus.warning,
        ),
        _m(
          key: 'balance',
          label: '平衡',
          kind: MetricKind.enumeration,
          value: 59,
          unit: '分',
          category: 'mobility',
          status: MetricStatus.warning,
        ),
        _m(
          key: 'endurance',
          label: '耐力',
          kind: MetricKind.enumeration,
          value: 58,
          unit: '分',
          category: 'mobility',
          status: MetricStatus.normal,
        ),
        _m(
          key: 'flexibility',
          label: '柔韌',
          kind: MetricKind.enumeration,
          value: 61,
          unit: '分',
          category: 'mobility',
          status: MetricStatus.normal,
        ),
        _m(
          key: 'coordination',
          label: '協調',
          kind: MetricKind.enumeration,
          value: 56,
          unit: '分',
          category: 'mobility',
          status: MetricStatus.warning,
        ),
      ],
    ),
  ];

  // 患者 3：維持期，恢復良好（風險低）
  final p3 = PatientProfile(
    patientId: 'P-1003',
    displayName: '床號 B-03 · 匿稱「健」',
    dateOfBirth: _d(1972, 1, 22),
    heightCm: 160,
    weightKg: 58,
    rehabStage: '維持期',
    expertId: 'expert-01',
    isActive: true,
  );
  final p3Snaps = [
    RehabSnapshot(
      patientId: 'P-1003',
      batchId: 'B-1003-1',
      testDate: _d(2026, 7, 10),
      summary: const SnapshotSummary(
        completionRate: 90,
        trendDirection: 'flat',
        riskLevel: RehabRisk.low,
        note: '恢復良好，進入維持期，維持現有訓練強度。',
      ),
      metrics: [
        _m(
          key: 'completionRate',
          label: '運動完成率',
          kind: MetricKind.percentage,
          value: 90,
          unit: '%',
          status: MetricStatus.normal,
          series: [
            _tp(_d(2026, 6, 20), 86, 'completionRate'),
            _tp(_d(2026, 6, 30), 88, 'completionRate'),
            _tp(_d(2026, 7, 10), 90, 'completionRate'),
          ],
        ),
        _m(
          key: 'balanceScore',
          label: '平衡評分',
          kind: MetricKind.score,
          value: 82,
          unit: '分',
          status: MetricStatus.normal,
        ),
        _m(
          key: 'romKnee',
          label: '膝關節活動度',
          kind: MetricKind.numeric,
          value: 122,
          unit: '°',
          referenceRange:
              const ReferenceRange(
                low: 0,
                high: 135,
                normalLow: 110,
                normalHigh: 135,
              ),
          status: MetricStatus.normal,
          series: [
            _tp(_d(2026, 6, 20), 118, 'romKnee'),
            _tp(_d(2026, 6, 30), 120, 'romKnee'),
            _tp(_d(2026, 7, 10), 122, 'romKnee'),
          ],
        ),
        _m(
          key: 'strength',
          label: '肌力',
          kind: MetricKind.enumeration,
          value: 80,
          unit: '分',
          category: 'mobility',
          status: MetricStatus.normal,
        ),
        _m(
          key: 'balance',
          label: '平衡',
          kind: MetricKind.enumeration,
          value: 81,
          unit: '分',
          category: 'mobility',
          status: MetricStatus.normal,
        ),
        _m(
          key: 'endurance',
          label: '耐力',
          kind: MetricKind.enumeration,
          value: 79,
          unit: '分',
          category: 'mobility',
          status: MetricStatus.normal,
        ),
        _m(
          key: 'flexibility',
          label: '柔韌',
          kind: MetricKind.enumeration,
          value: 83,
          unit: '分',
          category: 'mobility',
          status: MetricStatus.normal,
        ),
        _m(
          key: 'coordination',
          label: '協調',
          kind: MetricKind.enumeration,
          value: 80,
          unit: '分',
          category: 'mobility',
          status: MetricStatus.normal,
        ),
      ],
    ),
    RehabSnapshot(
      patientId: 'P-1003',
      batchId: 'B-1003-2',
      testDate: _d(2026, 8, 10),
      summary: const SnapshotSummary(
        completionRate: 92,
        trendDirection: 'up',
        riskLevel: RehabRisk.low,
        note: '維持期穩定，指標達標，可考慮減頻訓練。',
      ),
      metrics: [
        _m(
          key: 'completionRate',
          label: '運動完成率',
          kind: MetricKind.percentage,
          value: 92,
          unit: '%',
          status: MetricStatus.normal,
          series: [
            _tp(_d(2026, 7, 20), 90, 'completionRate'),
            _tp(_d(2026, 7, 30), 91, 'completionRate'),
            _tp(_d(2026, 8, 10), 92, 'completionRate'),
          ],
        ),
        _m(
          key: 'balanceScore',
          label: '平衡評分',
          kind: MetricKind.score,
          value: 85,
          unit: '分',
          status: MetricStatus.normal,
        ),
        _m(
          key: 'romKnee',
          label: '膝關節活動度',
          kind: MetricKind.numeric,
          value: 126,
          unit: '°',
          referenceRange:
              const ReferenceRange(
                low: 0,
                high: 135,
                normalLow: 110,
                normalHigh: 135,
              ),
          status: MetricStatus.normal,
          series: [
            _tp(_d(2026, 7, 20), 123, 'romKnee'),
            _tp(_d(2026, 7, 30), 125, 'romKnee'),
            _tp(_d(2026, 8, 10), 126, 'romKnee'),
          ],
        ),
        _m(
          key: 'strength',
          label: '肌力',
          kind: MetricKind.enumeration,
          value: 84,
          unit: '分',
          category: 'mobility',
          status: MetricStatus.normal,
        ),
        _m(
          key: 'balance',
          label: '平衡',
          kind: MetricKind.enumeration,
          value: 84,
          unit: '分',
          category: 'mobility',
          status: MetricStatus.normal,
        ),
        _m(
          key: 'endurance',
          label: '耐力',
          kind: MetricKind.enumeration,
          value: 82,
          unit: '分',
          category: 'mobility',
          status: MetricStatus.normal,
        ),
        _m(
          key: 'flexibility',
          label: '柔韌',
          kind: MetricKind.enumeration,
          value: 86,
          unit: '分',
          category: 'mobility',
          status: MetricStatus.normal,
        ),
        _m(
          key: 'coordination',
          label: '協調',
          kind: MetricKind.enumeration,
          value: 83,
          unit: '分',
          category: 'mobility',
          status: MetricStatus.normal,
        ),
      ],
    ),
  ];

  return [
    _DemoPayload(patient: p1, snapshots: p1Snaps),
    _DemoPayload(patient: p2, snapshots: p2Snaps),
    _DemoPayload(patient: p3, snapshots: p3Snaps),
  ];
}

/// 載入內置 demo 種子：逐患者經由 `repo.import()` 走完整
/// 解析 → 入庫 → 審計 路徑（與真實匯入同源），確保演示與生產一致。
Future<void> loadDemoSeed(RehabRepository repo) async {
  for (final payload in _buildDemoPayloads()) {
    final json = jsonEncode({
      'patient': payload.patient.toJson(),
      'snapshots':
          payload.snapshots.map((s) => s.toJson()).toList(),
    });
    await repo.import(json, ImportFormat.json);
  }
}
