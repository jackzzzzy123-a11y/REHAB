// lib/main.dart
//
// 應用入口。初始化順序：環境設定(dart-define) → Hive → 還原會話 → Router → l10n。
//
// 合規提示（PDPO / 醫健通）：
// - 絕不於此處或任何地方硬編碼真實病人資料；開發/測試僅使用脫敏虛擬 fixtures。
// - 敏感設定（API 憑證、加解密金鑰）經 core/config 由 dart-define 讀取，不落 .env。
// - 本應用定位為輔助工具，不替代醫生親身診症。

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app/app.dart';
import 'core/config/app_config.dart';
import 'core/notification/notification_providers.dart';
import 'features/auth/providers/auth_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 讀取 dart-define 環境設定（見 core/config/app_config.dart, §8.2）
  AppConfig.init();

  // 初始化本地加密儲存（Hive，僅快取脫敏後的唯讀檢視資料）
  await Hive.initFlutter();

  // 啟動依賴容器；初始化本機通知（匯入完成等事件；平台未配置不阻塞）
  final container = ProviderContainer();
  try {
    await container.read(notificationServiceProvider).init();
  } catch (_) {
    // 通知平台未配置不影響核心流程
  }

  // 啟動時還原已登入會話（若有持久化 token）
  await container.read(authNotifierProvider.notifier).restoreSession();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const RehabMedApp(),
    ),
  );
}
