// test/dashboard_flow_test.dart
//
// Dashboard 主從佈局 widget 測試（P1-4）：
//   寬屏（≥720）→ 左患者清單 + 右分析面板；下鑽 Tab 可切換；搜尋可過濾清單。
// 真實 IO（Hive 種子/預熱）包在 tester.runAsync 內；測試體只讀緩存值。
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

import 'package:rehab_med/data/models/patient_profile.dart';
import 'package:rehab_med/features/patient_dashboard/dashboard_page.dart';
import 'package:rehab_med/features/patient_dashboard/data/demo_seed.dart';
import 'package:rehab_med/features/patient_dashboard/providers/dashboard_providers.dart';
import 'package:rehab_med/l10n/generated/app_localizations.dart';

import 'helpers/test_env.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  tearDown(() async => Hive.close());

  Widget wrap(ProviderContainer container) => UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: [Locale('zh', 'HK'), Locale('en')],
          locale: Locale('zh', 'HK'),
          home: DashboardPage(),
        ),
      );

  Future<(TestEnv, List<PatientProfile>, PatientProfile)> warmEnv(
    WidgetTester tester,
  ) async {
    final result = await tester.runAsync(() async {
      final env = await buildTestEnv();
      await loadDemoSeed(env.repo);
      final patients = await env.container.read(patientsProvider.future);
      final first = patients.first;
      await env.container.read(snapshotsProvider(first.patientId).future);
      await env.container.read(mediaProvider(first.patientId).future);
      return (env, patients, first);
    });
    return result!;
  }

  testWidgets('主從佈局：患者清單 + 分析面板 + 下鑽 Tab 切換', (tester) async {
    // 放大視口，確保 420 高面板內的下鑽 Tab 全部可見可點。
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final (env, _, first) = await warmEnv(tester);
    addTearDown(env.container.dispose);

    await tester.pumpWidget(wrap(env.container));
    await tester.pumpAndSettle();

    // 左清單：首名患者名可見
    expect(find.text(first.displayName), findsWidgets);
    // 搜尋欄存在（主從左欄）
    expect(find.byType(TextField), findsOneWidget);

    // 下鑽 Tab 切換：運動分布 → 歷次測試 → 輔助媒體
    await tester.tap(find.text('歷次測試'));
    await tester.pumpAndSettle();
    expect(find.text('歷次測試'), findsWidgets);

    await tester.tap(find.text('輔助媒體'));
    await tester.pumpAndSettle();
    expect(find.text('暫無輔助媒體（P2 填充）'), findsOneWidget);
  });

  testWidgets('搜尋過濾患者清單', (tester) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final (env, _, first) = await warmEnv(tester);
    addTearDown(env.container.dispose);

    await tester.pumpWidget(wrap(env.container));
    await tester.pumpAndSettle();
    expect(find.text(first.displayName), findsWidgets);

    // 輸入不存在的關鍵字 → 列表空提示
    await tester.enterText(find.byType(TextField).first, '不存在的關鍵字');
    await tester.pumpAndSettle();
    expect(find.text('暫無患者資料'), findsOneWidget);
  });
}
