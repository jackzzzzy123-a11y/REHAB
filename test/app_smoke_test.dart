// test/app_smoke_test.dart
//
// 冒烟 widget 测试：App 啟動可達登入頁；設定頁三段（外觀/長者/安全鎖）正常渲染。
// 目標：P1 全部功能接线後，確保根元件可建構、l10n 鍵齊全、三块設定 UI 不炸。
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rehab_med/app/app.dart';
import 'package:rehab_med/features/settings/settings_page.dart';
import 'package:rehab_med/l10n/generated/app_localizations.dart';

void main() {
  testWidgets('App 啟動後進入登入頁', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: RehabMedApp()));
    await tester.pumpAndSettle();
    expect(find.text('登入'), findsWidgets);
  });

  testWidgets('設定頁渲染 外觀/長者/安全鎖 三段', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: [Locale('zh', 'HK'), Locale('en')],
          locale: Locale('zh', 'HK'),
          home: SettingsPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    // #9 外觀
    expect(find.text('主題'), findsOneWidget);
    expect(find.text('跟隨系統'), findsOneWidget);
    // #10 長者模式（測試環境系統縮放 1.0 → 自動 off，開關與說明可見）
    expect(find.text('長者模式'), findsOneWidget);
    expect(find.textContaining('自動'), findsWidgets);
    // #13 安全鎖（預設啟用，逾時選項可見）
    expect(find.text('安全鎖'), findsOneWidget);
    expect(find.text('3 分鐘'), findsOneWidget);
  });
}
