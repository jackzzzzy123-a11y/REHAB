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
    const locale = Locale('zh', 'HK');
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: [locale, Locale('en')],
          locale: locale,
          home: SettingsPage(),
        ),
      ),
    );
    // 用 pump() 而非 pumpAndSettle()：純文字煙測一幀即定型。
    // P2-a 新增的「專家年齡」TextFormField（suffixText + initialValue）
    // 在 test 環境下 pumpAndSettle 偶發不收斂。
    await tester.pump();
    // 直接取 app 實際使用的 l10n 實例來斷言，避免硬編 literal
    // 與生成檔（zh_HK 傳統 / 泛型 zh 簡體同 key 異值）字元或語系不一致而脆斷。
    final l10n = AppLocalizations.of(
      tester.element(find.byType(SettingsPage)),
    )!;
    // #9 外觀
    expect(find.text(l10n.themeTitle), findsOneWidget);
    expect(find.text(l10n.themeModeSystem), findsOneWidget);
    // #10 長者模式（測試環境系統縮放 1.0 → 自動 off，開關與說明可見）
    expect(find.text(l10n.elderTitle), findsOneWidget);
    expect(find.textContaining('自動'), findsWidgets);
    // P2-a 專家端年齡輸入（§11 專家端長者模式觸發：年滿 65 自動開）
    expect(find.text('專家年齡'), findsOneWidget);
    expect(find.byType(TextFormField), findsOneWidget);
    // #13 安全鎖（預設啟用，逾時選項可見）
    expect(find.text(l10n.lockTitle), findsOneWidget);
    expect(find.text(l10n.lockTimeoutMin3), findsOneWidget);
  });
}
