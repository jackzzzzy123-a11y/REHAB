// test/auth_flow_test.dart
//
// 登入流程 widget 測試（P0-1）：
//   醫生登入 → /doctor；患者登入 → /patient；未勾選同意 → 提示不跳轉。
// 以 RehabMedApp 全路由泵送；真實 IO（Hive 種子/預熱）一律包在 tester.runAsync 內，
// 測試體只讀已緩存 provider 值，避免 FakeAsync 死鎖。
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

import 'package:rehab_med/app/app.dart';
import 'package:rehab_med/features/patient_dashboard/dashboard_page.dart';
import 'package:rehab_med/features/patient_dashboard/data/demo_seed.dart';
import 'package:rehab_med/features/patient_dashboard/providers/dashboard_providers.dart';
import 'package:rehab_med/features/patient_home/patient_home_page.dart';

import 'helpers/test_env.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  tearDown(() async => Hive.close());

  Future<TestEnv> warmEnv(WidgetTester tester) async {
    final env = await tester.runAsync(() async {
      final e = await buildTestEnv();
      await loadDemoSeed(e.repo);
      await e.container.read(patientsProvider.future);
      final first = (await e.container.read(patientsProvider.future)).first;
      await e.container.read(snapshotsProvider(first.patientId).future);
      await e.container.read(mediaProvider(first.patientId).future);
      return e;
    });
    return env!;
  }

  Future<void> pumpApp(WidgetTester tester, TestEnv env) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: env.container,
        child: const RehabMedApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> fillAndSubmit(
    WidgetTester tester, {
    String username = 'doctor1',
    String password = '123456',
    bool consent = true,
  }) async {
    await tester.enterText(find.byType(TextFormField).at(0), username);
    await tester.enterText(find.byType(TextFormField).at(1), password);
    if (consent) {
      await tester.tap(find.byType(CheckboxListTile));
      await tester.pump();
    }
    await tester.tap(find.widgetWithText(FilledButton, '登入'));
    await tester.pumpAndSettle();
  }

  testWidgets('醫生登入 → 跳轉 /doctor（DashboardPage）', (tester) async {
    final env = await warmEnv(tester);
    addTearDown(env.container.dispose);

    await pumpApp(tester, env);
    expect(find.byType(DashboardPage), findsNothing);

    await fillAndSubmit(tester);

    expect(find.byType(DashboardPage), findsOneWidget);
    // 患者列表已渲染（預熱過 provider）
    expect(find.byType(ListTile), findsWidgets);
  });

  testWidgets('患者登入 → 跳轉 /patient（PatientHomePage）', (tester) async {
    final env = await warmEnv(tester);
    addTearDown(env.container.dispose);

    await pumpApp(tester, env);

    // 切換角色為患者
    await tester.tap(find.text('患者 / 家屬'));
    await tester.pump();
    await fillAndSubmit(tester);

    expect(find.byType(PatientHomePage), findsOneWidget);
  });

  testWidgets('未勾選同意 → 提示且不跳轉', (tester) async {
    final env = await warmEnv(tester);
    addTearDown(env.container.dispose);

    await pumpApp(tester, env);
    await fillAndSubmit(tester, consent: false);

    expect(find.text('請先同意個人資料收集聲明'), findsOneWidget);
    expect(find.byType(DashboardPage), findsNothing);
  });
}
