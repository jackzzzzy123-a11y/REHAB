// lib/features/patient_dashboard/patient_detail_page.dart
//
// 個案分析詳情（全屏）。窄屏主從佈局點選 / 深鏈接進入時使用；
// 大屏則由 Dashboard 右側面板內嵌同一 PatientAnalyticsPanel。
// 合規：路由含 patientId 參數，但不於 URI 暴露任何病人敏感欄位。

import 'package:flutter/material.dart';

import 'analytics/patient_analytics_panel.dart';

class PatientDetailPage extends StatelessWidget {
  const PatientDetailPage({required this.patientId, super.key});

  final String patientId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(patientId)),
      body: PatientAnalyticsPanel(
        patientId: patientId,
        displayName: patientId,
      ),
    );
  }
}
