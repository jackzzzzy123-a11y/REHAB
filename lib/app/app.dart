// lib/app/app.dart
//
// 根元件：組裝 MaterialApp + Router + 主題 + 多語 + 安全鎖。
// 合規：預設繁體中文（香港）；路由含 RBAC 守衛。
// 無障礙：不覆寫系統字體縮放（尊重系統設定，符合 WCAG 2.2 / 香港《無障礙流動應用程式手冊》）。
// #9：角色感知雙主題 —— theme/darkTheme 依當前角色 seed，themeMode 由設定切換。
// #10：長者模式 —— 系統大字自動 / 手動覆蓋 / 字號可調（builder 內縮放）。
// #13：安全鎖 —— 前台切回逾時上鎖，鎖屏覆蓋整個 App（進任意頁前先驗證）。

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rehab_med/l10n/generated/app_localizations.dart';

import '../features/auth/domain/user_role.dart';
import '../features/auth/providers/auth_provider.dart';
import 'localization/l10n.dart';
import 'router/app_router.dart';
import 'security/lock_providers.dart';
import 'security/lock_screen.dart';
import 'theme/app_theme.dart';
import 'theme/theme_providers.dart';

class RehabMedApp extends ConsumerStatefulWidget {
  const RehabMedApp({super.key});

  @override
  ConsumerState<RehabMedApp> createState() => _RehabMedAppState();
}

class _RehabMedAppState extends ConsumerState<RehabMedApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // 前台切回：逾時則上鎖（#13）。
    if (state == AppLifecycleState.resumed) {
      final enabled = ref.read(lockEnabledProvider);
      if (enabled) {
        final timeout = ref.read(lockTimeoutProvider);
        ref.read(lockControllerProvider.notifier).onResume(timeout: timeout);
      } else {
        ref.read(lockControllerProvider.notifier).recordActivity();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);
    // #10 長者模式：自動 + 手動 + 可調
    final elder = effectiveElder(
      override: ref.watch(elderOverrideProvider),
    );
    final contrast = ref.watch(elderContrastProvider);
    final scale = ref.watch(elderScaleProvider);
    // #13 安全鎖
    final lockState = ref.watch(lockControllerProvider);
    // 角色感知：醫生藍 / 患者青綠；未登入時預設醫生藍。
    final role =
        ref.watch(authNotifierProvider.select((s) => s.user?.role)) ??
            UserRole.doctor;

    // 登入成功視為一次活動，開始計時安全鎖。
    ref.listen(authNotifierProvider, (prev, next) {
      if (next.isLoggedIn && !(prev?.isLoggedIn ?? false)) {
        ref.read(lockControllerProvider.notifier).recordActivity();
      }
    });

    return MaterialApp.router(
      title: 'RehabMed',
      // 繁體中文（香港）為主，英文為輔
      locale: ref.watch(localeProvider),
      supportedLocales: const [Locale('zh', 'HK'), Locale('en')],
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      theme: AppTheme.forRole(role, elder: elder, highContrast: contrast),
      darkTheme: AppTheme.forRole(
        role,
        brightness: Brightness.dark,
        elder: elder,
        highContrast: contrast,
      ),
      themeMode: themeMode,
      // 長者模式縮放 + 安全鎖覆蓋（鎖定整個 App）。
      builder: (context, child) {
        var content = child;
        if (elder && content != null) {
          content = MediaQuery.withClampedTextScaling(
            minScaleFactor: scale,
            child: content,
          );
        }
        if (lockState.locked) {
          content = const LockScreen();
        }
        return content ?? const SizedBox.shrink();
      },
      routerConfig: router,
    );
  }
}
